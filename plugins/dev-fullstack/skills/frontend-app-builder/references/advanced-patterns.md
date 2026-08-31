# Advanced Patterns Reference

Table des matières :
1. [Formulaires avec validation](#formulaires)
2. [Dark mode toggle](#dark-mode)
3. [Pagination & Infinite scroll](#pagination)
4. [Optimistic updates](#optimistic-updates)
5. [Debounced search](#debounced-search)
6. [Auth avec Supabase](#auth-supabase)
7. [WebSocket / Real-time](#websocket)
8. [File upload](#file-upload)

---

## Formulaires

Pattern de formulaire avec validation côté client, gestion des erreurs, et soumission.

```tsx
import { useState, type FormEvent } from 'react'
import { Input } from '@/components/ui/Input'
import { Button } from '@/components/ui/Button'

interface FormData {
  name: string
  email: string
  amount: string
}

interface FormErrors {
  name?: string
  email?: string
  amount?: string
}

function validate(data: FormData): FormErrors {
  const errors: FormErrors = {}
  if (!data.name.trim()) errors.name = 'Le nom est requis'
  if (!data.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) errors.email = 'Email invalide'
  if (isNaN(Number(data.amount)) || Number(data.amount) <= 0) errors.amount = 'Montant invalide'
  return errors
}

export function ExampleForm({ onSubmit }: { onSubmit: (data: FormData) => Promise<void> }) {
  const [form, setForm] = useState<FormData>({ name: '', email: '', amount: '' })
  const [errors, setErrors] = useState<FormErrors>({})
  const [isSubmitting, setIsSubmitting] = useState(false)

  function updateField(field: keyof FormData, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }))
    // Clear error on edit
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: undefined }))
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    const validationErrors = validate(form)
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors)
      return
    }
    setIsSubmitting(true)
    try {
      await onSubmit(form)
    } catch {
      setErrors({ name: 'Erreur lors de la soumission' })
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4" noValidate>
      <Input label="Nom" value={form.name} onChange={(e) => updateField('name', e.target.value)} error={errors.name} required />
      <Input label="Email" type="email" value={form.email} onChange={(e) => updateField('email', e.target.value)} error={errors.email} required />
      <Input label="Montant (CHF)" type="number" value={form.amount} onChange={(e) => updateField('amount', e.target.value)} error={errors.amount} required />
      <Button type="submit" isLoading={isSubmitting}>Envoyer</Button>
    </form>
  )
}
```

---

## Dark Mode

Toggle dark/light/auto via une classe sur `<html>` et Tailwind `dark:` variants.

```tsx
// hooks/useTheme.ts
import { useState, useEffect } from 'react'

type Theme = 'light' | 'dark' | 'system'

export function useTheme() {
  const [theme, setThemeState] = useState<Theme>(() => {
    if (typeof window === 'undefined') return 'system'
    return (window.localStorage.getItem('theme') as Theme) ?? 'system'
  })

  useEffect(() => {
    const root = document.documentElement
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')

    function apply() {
      const isDark = theme === 'dark' || (theme === 'system' && mediaQuery.matches)
      root.classList.toggle('dark', isDark)
    }

    apply()
    mediaQuery.addEventListener('change', apply)
    return () => mediaQuery.removeEventListener('change', apply)
  }, [theme])

  function setTheme(newTheme: Theme) {
    setThemeState(newTheme)
    window.localStorage.setItem('theme', newTheme)
  }

  return { theme, setTheme }
}
```

```tsx
// components/ui/ThemeToggle.tsx
import { useTheme } from '@/hooks/useTheme'

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()

  const options = [
    { value: 'light' as const, label: 'Clair', icon: '☀️' },
    { value: 'dark' as const, label: 'Sombre', icon: '🌙' },
    { value: 'system' as const, label: 'Auto', icon: '💻' },
  ]

  return (
    <div className="flex rounded-lg border border-gray-200 dark:border-gray-700" role="radiogroup" aria-label="Thème">
      {options.map((opt) => (
        <button
          key={opt.value}
          role="radio"
          aria-checked={theme === opt.value}
          onClick={() => setTheme(opt.value)}
          className={`px-3 py-1.5 text-sm transition-colors first:rounded-l-lg last:rounded-r-lg
            ${theme === opt.value
              ? 'bg-blue-600 text-white'
              : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800'}`}
        >
          <span aria-hidden="true">{opt.icon}</span>
          <span className="sr-only">{opt.label}</span>
        </button>
      ))}
    </div>
  )
}
```

### Configuration Tailwind pour dark mode

```js
// tailwind.config.js
export default { darkMode: 'class' }
```

---

## Pagination

### Pattern avec URL search params (recommandé)

```tsx
import { useSearchParams } from 'react-router-dom'

export function usePagination(defaultPageSize = 20) {
  const [searchParams, setSearchParams] = useSearchParams()
  const page = Number(searchParams.get('page')) || 1
  const pageSize = Number(searchParams.get('size')) || defaultPageSize

  function setPage(newPage: number) {
    setSearchParams((prev) => {
      prev.set('page', String(newPage))
      return prev
    })
  }

  return { page, pageSize, setPage, offset: (page - 1) * pageSize }
}
```

```tsx
// components/ui/Pagination.tsx
interface PaginationProps {
  page: number
  totalPages: number
  onPageChange: (page: number) => void
}

export function Pagination({ page, totalPages, onPageChange }: PaginationProps) {
  return (
    <nav aria-label="Pagination" className="flex items-center justify-center gap-2">
      <button
        onClick={() => onPageChange(page - 1)}
        disabled={page <= 1}
        className="rounded-lg px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 disabled:opacity-40 dark:text-gray-400 dark:hover:bg-gray-800"
      >
        Précédent
      </button>
      <span className="text-sm text-gray-500">
        Page {page} sur {totalPages}
      </span>
      <button
        onClick={() => onPageChange(page + 1)}
        disabled={page >= totalPages}
        className="rounded-lg px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 disabled:opacity-40 dark:text-gray-400 dark:hover:bg-gray-800"
      >
        Suivant
      </button>
    </nav>
  )
}
```

---

## Optimistic Updates

Pattern pour mettre à jour l'UI immédiatement, puis synchroniser avec le serveur.

```typescript
// Exemple dans un store Zustand
interface TodoState {
  todos: Todo[]
  toggleTodo: (id: string) => Promise<void>
}

export const useTodoStore = create<TodoState>((set, get) => ({
  todos: [],
  toggleTodo: async (id) => {
    // 1. Sauvegarder l'état actuel
    const previousTodos = get().todos

    // 2. Mise à jour optimiste
    set((s) => ({
      todos: s.todos.map((t) =>
        t.id === id ? { ...t, completed: !t.completed } : t
      ),
    }))

    // 3. Sync avec le serveur
    try {
      await todoService.toggle(id)
    } catch {
      // 4. Rollback en cas d'erreur
      set({ todos: previousTodos })
      useToastStore.getState().addToast('Échec de la mise à jour', 'error')
    }
  },
}))
```

---

## Debounced Search

```tsx
import { useState, useEffect, useRef } from 'react'

export function useDebouncedValue<T>(value: T, delay = 300): T {
  const [debouncedValue, setDebouncedValue] = useState(value)

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(timer)
  }, [value, delay])

  return debouncedValue
}

// Usage dans un composant de recherche
export function SearchInput({ onSearch }: { onSearch: (query: string) => void }) {
  const [query, setQuery] = useState('')
  const debouncedQuery = useDebouncedValue(query, 300)
  const isFirstRender = useRef(true)

  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false
      return
    }
    onSearch(debouncedQuery)
  }, [debouncedQuery, onSearch])

  return (
    <div className="relative">
      <svg className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
        <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
      </svg>
      <input
        type="search"
        placeholder="Rechercher..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="w-full rounded-lg border border-gray-300 bg-white py-2 pl-10 pr-4 text-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20 dark:border-gray-700 dark:bg-gray-900 dark:text-white"
      />
    </div>
  )
}
```

---

## Auth Supabase

Alternative à l'auth custom, quand l'utilisateur utilise Supabase comme backend.

```typescript
// services/supabase.ts
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)
```

```typescript
// hooks/useSupabaseAuth.ts
import { useEffect } from 'react'
import { supabase } from '@/services/supabase'
import { useAuthStore } from '@/stores/authStore'

export function useSupabaseAuth() {
  const { login, logout } = useAuthStore()

  useEffect(() => {
    // Check existing session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        login(
          { id: session.user.id, email: session.user.email!, name: session.user.user_metadata.name ?? '', role: 'user' },
          session.access_token
        )
      }
    })

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        login(
          { id: session.user.id, email: session.user.email!, name: session.user.user_metadata.name ?? '', role: 'user' },
          session.access_token
        )
      } else {
        logout()
      }
    })

    return () => subscription.unsubscribe()
  }, [login, logout])
}
```

---

## WebSocket

Pattern pour les fonctionnalités temps réel.

```typescript
// hooks/useWebSocket.ts
import { useEffect, useRef, useCallback } from 'react'

interface UseWebSocketOptions {
  url: string
  onMessage: (data: unknown) => void
  onError?: (error: Event) => void
  reconnectDelay?: number
}

export function useWebSocket({ url, onMessage, onError, reconnectDelay = 3000 }: UseWebSocketOptions) {
  const wsRef = useRef<WebSocket | null>(null)
  const reconnectTimer = useRef<ReturnType<typeof setTimeout>>()

  const connect = useCallback(() => {
    const ws = new WebSocket(url)
    wsRef.current = ws

    ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data)
        onMessage(data)
      } catch {
        onMessage(event.data)
      }
    }

    ws.onerror = (event) => onError?.(event)

    ws.onclose = () => {
      reconnectTimer.current = setTimeout(connect, reconnectDelay)
    }
  }, [url, onMessage, onError, reconnectDelay])

  useEffect(() => {
    connect()
    return () => {
      clearTimeout(reconnectTimer.current)
      wsRef.current?.close()
    }
  }, [connect])

  const send = useCallback((data: unknown) => {
    if (wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(JSON.stringify(data))
    }
  }, [])

  return { send }
}
```

---

## File Upload

```tsx
import { useState, useRef, type ChangeEvent, type DragEvent } from 'react'

interface FileUploadProps {
  accept?: string
  maxSizeMB?: number
  onUpload: (file: File) => Promise<void>
}

export function FileUpload({ accept, maxSizeMB = 10, onUpload }: FileUploadProps) {
  const [isDragging, setIsDragging] = useState(false)
  const [isUploading, setIsUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  async function handleFile(file: File) {
    if (maxSizeMB && file.size > maxSizeMB * 1024 * 1024) {
      setError(`Fichier trop lourd (max ${maxSizeMB} MB)`)
      return
    }
    setError(null)
    setIsUploading(true)
    try {
      await onUpload(file)
    } catch {
      setError("Erreur lors de l'upload")
    } finally {
      setIsUploading(false)
    }
  }

  function handleChange(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (file) handleFile(file)
  }

  function handleDrop(e: DragEvent) {
    e.preventDefault()
    setIsDragging(false)
    const file = e.dataTransfer.files[0]
    if (file) handleFile(file)
  }

  return (
    <div
      onClick={() => inputRef.current?.click()}
      onDragOver={(e) => { e.preventDefault(); setIsDragging(true) }}
      onDragLeave={() => setIsDragging(false)}
      onDrop={handleDrop}
      className={`
        flex cursor-pointer flex-col items-center gap-2 rounded-xl border-2 border-dashed p-8
        transition-colors
        ${isDragging
          ? 'border-blue-500 bg-blue-50 dark:bg-blue-950/20'
          : 'border-gray-300 hover:border-gray-400 dark:border-gray-700 dark:hover:border-gray-600'}
      `}
    >
      <input ref={inputRef} type="file" accept={accept} onChange={handleChange} className="hidden" />
      {isUploading ? (
        <p className="text-sm text-gray-500">Upload en cours...</p>
      ) : (
        <>
          <p className="text-sm font-medium text-gray-700 dark:text-gray-300">
            Glissez un fichier ici ou cliquez pour sélectionner
          </p>
          <p className="text-xs text-gray-400">Max {maxSizeMB} MB</p>
        </>
      )}
      {error && <p className="text-sm text-red-600">{error}</p>}
    </div>
  )
}
```
