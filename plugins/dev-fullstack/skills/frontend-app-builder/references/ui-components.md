# UI Components Reference

Table des matières :
1. [Input](#input)
2. [Card](#card)
3. [Modal](#modal)
4. [Badge](#badge)
5. [Avatar](#avatar)
6. [Table](#table)
7. [Tabs](#tabs)
8. [Toast / Notifications](#toast)
9. [Sidebar](#sidebar)
10. [Header](#header)
11. [PageSkeleton](#pageskeleton)

---

## Input

```tsx
import { type InputHTMLAttributes, forwardRef, useId } from 'react'

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string
  hint?: string
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, hint, className = '', id: providedId, ...props }, ref) => {
    const autoId = useId()
    const id = providedId ?? autoId
    const hintId = hint ? `${id}-hint` : undefined
    const errorId = error ? `${id}-error` : undefined

    return (
      <div className="space-y-1.5">
        <label htmlFor={id} className="block text-sm font-medium text-gray-700 dark:text-gray-300">
          {label}
        </label>
        <input
          ref={ref}
          id={id}
          aria-describedby={errorId ?? hintId}
          aria-invalid={!!error}
          className={`
            block w-full rounded-lg border bg-white px-3 py-2 text-sm
            transition-colors placeholder:text-gray-400
            focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1
            dark:bg-gray-900 dark:text-white dark:placeholder:text-gray-500
            ${error
              ? 'border-red-500 focus:ring-red-500'
              : 'border-gray-300 dark:border-gray-700'}
            ${className}
          `.trim()}
          {...props}
        />
        {error && (
          <p id={errorId} role="alert" className="text-sm text-red-600 dark:text-red-400">
            {error}
          </p>
        )}
        {hint && !error && (
          <p id={hintId} className="text-sm text-gray-500">{hint}</p>
        )}
      </div>
    )
  }
)

Input.displayName = 'Input'
```

---

## Card

```tsx
interface CardProps {
  children: React.ReactNode
  className?: string
  hover?: boolean
  onClick?: () => void
}

export function Card({ children, className = '', hover = false, onClick }: CardProps) {
  const interactive = hover || !!onClick
  const Tag = onClick ? 'button' : 'div'

  return (
    <Tag
      onClick={onClick}
      className={`
        rounded-xl border border-gray-200 bg-white p-5
        dark:border-gray-800 dark:bg-gray-900
        ${interactive ? 'cursor-pointer transition-all hover:-translate-y-0.5 hover:shadow-lg hover:border-gray-300 dark:hover:border-gray-700' : ''}
        ${onClick ? 'text-left w-full' : ''}
        ${className}
      `.trim()}
    >
      {children}
    </Tag>
  )
}

// Sous-composants pour structure cohérente
Card.Header = function CardHeader({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <div className={`mb-3 flex items-center justify-between ${className}`}>{children}</div>
}

Card.Title = function CardTitle({ children }: { children: React.ReactNode }) {
  return <h3 className="text-lg font-semibold text-gray-900 dark:text-white">{children}</h3>
}

Card.Body = function CardBody({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <div className={className}>{children}</div>
}

Card.Footer = function CardFooter({ children }: { children: React.ReactNode }) {
  return <div className="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4 dark:border-gray-800">{children}</div>
}
```

---

## Modal

```tsx
import { useEffect, useRef, type ReactNode } from 'react'

interface ModalProps {
  isOpen: boolean
  onClose: () => void
  title: string
  description?: string
  children: ReactNode
  footer?: ReactNode
}

export function Modal({ isOpen, onClose, title, description, children, footer }: ModalProps) {
  const dialogRef = useRef<HTMLDialogElement>(null)
  const previousFocus = useRef<HTMLElement | null>(null)

  useEffect(() => {
    const dialog = dialogRef.current
    if (!dialog) return

    if (isOpen) {
      previousFocus.current = document.activeElement as HTMLElement
      dialog.showModal()
    } else {
      dialog.close()
      previousFocus.current?.focus()
    }
  }, [isOpen])

  // Close on Escape
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape' && isOpen) onClose()
    }
    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [isOpen, onClose])

  if (!isOpen) return null

  return (
    <dialog
      ref={dialogRef}
      aria-labelledby="modal-title"
      aria-describedby={description ? 'modal-desc' : undefined}
      className="
        m-auto max-w-lg rounded-2xl border border-gray-200 bg-white p-0
        shadow-2xl backdrop:bg-black/50 dark:border-gray-700 dark:bg-gray-900
      "
      onClick={(e) => { if (e.target === dialogRef.current) onClose() }}
    >
      <div className="p-6">
        <h2 id="modal-title" className="text-xl font-semibold text-gray-900 dark:text-white">
          {title}
        </h2>
        {description && (
          <p id="modal-desc" className="mt-1 text-sm text-gray-500">{description}</p>
        )}
        <div className="mt-4">{children}</div>
      </div>
      {footer && (
        <div className="flex justify-end gap-2 border-t border-gray-100 px-6 py-4 dark:border-gray-800">
          {footer}
        </div>
      )}
    </dialog>
  )
}
```

---

## Badge

```tsx
const badgeVariants = {
  default: 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
  success: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
  warning: 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  danger: 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
  info: 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
} as const

interface BadgeProps {
  children: React.ReactNode
  variant?: keyof typeof badgeVariants
  dot?: boolean
}

export function Badge({ children, variant = 'default', dot = false }: BadgeProps) {
  return (
    <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium ${badgeVariants[variant]}`}>
      {dot && <span className="h-1.5 w-1.5 rounded-full bg-current" />}
      {children}
    </span>
  )
}
```

---

## Avatar

```tsx
interface AvatarProps {
  src?: string | null
  name: string
  size?: 'sm' | 'md' | 'lg'
}

const sizeMap = { sm: 'h-8 w-8 text-xs', md: 'h-10 w-10 text-sm', lg: 'h-14 w-14 text-lg' }

export function Avatar({ src, name, size = 'md' }: AvatarProps) {
  const initials = name.split(' ').map((n) => n[0]).join('').slice(0, 2).toUpperCase()

  if (src) {
    return <img src={src} alt={name} className={`${sizeMap[size]} rounded-full object-cover`} />
  }

  return (
    <div className={`${sizeMap[size]} flex items-center justify-center rounded-full bg-blue-100 font-semibold text-blue-600 dark:bg-blue-900 dark:text-blue-300`}>
      {initials}
    </div>
  )
}
```

---

## Table

```tsx
interface Column<T> {
  key: keyof T & string
  label: string
  render?: (value: T[keyof T], row: T) => React.ReactNode
  className?: string
}

interface DataTableProps<T extends { id: string | number }> {
  columns: Column<T>[]
  data: T[]
  isLoading?: boolean
  emptyMessage?: string
  onRowClick?: (row: T) => void
}

export function DataTable<T extends { id: string | number }>({
  columns, data, isLoading, emptyMessage = 'Aucune donnée', onRowClick,
}: DataTableProps<T>) {
  if (isLoading) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="h-12 animate-pulse rounded-lg bg-gray-100 dark:bg-gray-800" />
        ))}
      </div>
    )
  }

  if (data.length === 0) {
    return (
      <div className="py-12 text-center text-gray-500">{emptyMessage}</div>
    )
  }

  return (
    <div className="overflow-x-auto rounded-xl border border-gray-200 dark:border-gray-800">
      <table className="w-full text-left text-sm">
        <thead className="border-b border-gray-200 bg-gray-50 dark:border-gray-800 dark:bg-gray-900/50">
          <tr>
            {columns.map((col) => (
              <th key={col.key} className={`px-4 py-3 font-medium text-gray-500 dark:text-gray-400 ${col.className ?? ''}`}>
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
          {data.map((row) => (
            <tr
              key={row.id}
              onClick={() => onRowClick?.(row)}
              className={`${onRowClick ? 'cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/50' : ''}`}
            >
              {columns.map((col) => (
                <td key={col.key} className={`px-4 py-3 text-gray-900 dark:text-gray-100 ${col.className ?? ''}`}>
                  {col.render ? col.render(row[col.key], row) : String(row[col.key] ?? '')}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
```

---

## Tabs

```tsx
import { useState, useId } from 'react'

interface Tab {
  key: string
  label: string
  content: React.ReactNode
}

interface TabsProps {
  tabs: Tab[]
  defaultTab?: string
}

export function Tabs({ tabs, defaultTab }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultTab ?? tabs[0]?.key ?? '')
  const tablistId = useId()

  return (
    <div>
      <div role="tablist" aria-label="Onglets" className="flex gap-1 border-b border-gray-200 dark:border-gray-800">
        {tabs.map((tab) => (
          <button
            key={tab.key}
            role="tab"
            id={`${tablistId}-tab-${tab.key}`}
            aria-selected={activeTab === tab.key}
            aria-controls={`${tablistId}-panel-${tab.key}`}
            onClick={() => setActiveTab(tab.key)}
            className={`
              px-4 py-2.5 text-sm font-medium transition-colors
              ${activeTab === tab.key
                ? 'border-b-2 border-blue-600 text-blue-600 dark:border-blue-400 dark:text-blue-400'
                : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'}
            `}
          >
            {tab.label}
          </button>
        ))}
      </div>
      {tabs.map((tab) => (
        <div
          key={tab.key}
          role="tabpanel"
          id={`${tablistId}-panel-${tab.key}`}
          aria-labelledby={`${tablistId}-tab-${tab.key}`}
          hidden={activeTab !== tab.key}
          className="pt-4"
        >
          {tab.content}
        </div>
      ))}
    </div>
  )
}
```

---

## Toast

Système de notifications par toast, géré via un store Zustand dédié.

```tsx
// stores/toastStore.ts
import { create } from 'zustand'

type ToastVariant = 'success' | 'error' | 'info' | 'warning'

interface Toast {
  id: string
  message: string
  variant: ToastVariant
}

interface ToastState {
  toasts: Toast[]
  addToast: (message: string, variant?: ToastVariant) => void
  removeToast: (id: string) => void
}

export const useToastStore = create<ToastState>((set) => ({
  toasts: [],
  addToast: (message, variant = 'info') => {
    const id = crypto.randomUUID()
    set((s) => ({ toasts: [...s.toasts, { id, message, variant }] }))
    setTimeout(() => {
      set((s) => ({ toasts: s.toasts.filter((t) => t.id !== id) }))
    }, 4000)
  },
  removeToast: (id) =>
    set((s) => ({ toasts: s.toasts.filter((t) => t.id !== id) })),
}))
```

```tsx
// components/ui/ToastContainer.tsx
import { useToastStore } from '@/stores/toastStore'

const variantStyles = {
  success: 'border-green-500 bg-green-50 text-green-800 dark:bg-green-950 dark:text-green-300',
  error: 'border-red-500 bg-red-50 text-red-800 dark:bg-red-950 dark:text-red-300',
  info: 'border-blue-500 bg-blue-50 text-blue-800 dark:bg-blue-950 dark:text-blue-300',
  warning: 'border-amber-500 bg-amber-50 text-amber-800 dark:bg-amber-950 dark:text-amber-300',
}

export function ToastContainer() {
  const toasts = useToastStore((s) => s.toasts)
  const removeToast = useToastStore((s) => s.removeToast)

  return (
    <div className="fixed bottom-4 right-4 z-50 flex flex-col gap-2" aria-live="polite">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          role="status"
          className={`
            animate-slide-up rounded-lg border-l-4 px-4 py-3 text-sm shadow-lg
            ${variantStyles[toast.variant]}
          `}
        >
          <div className="flex items-center justify-between gap-3">
            <span>{toast.message}</span>
            <button
              onClick={() => removeToast(toast.id)}
              aria-label="Fermer"
              className="text-current opacity-50 hover:opacity-100"
            >
              &times;
            </button>
          </div>
        </div>
      ))}
    </div>
  )
}
```

---

## Sidebar

```tsx
import { NavLink } from 'react-router-dom'
import { useAuthStore } from '@/stores/authStore'

interface NavItem {
  to: string
  label: string
  icon: React.ReactNode
}

interface SidebarProps {
  items: NavItem[]
  appName?: string
}

export function Sidebar({ items, appName = 'App' }: SidebarProps) {
  const user = useAuthStore((s) => s.user)
  const logout = useAuthStore((s) => s.logout)

  return (
    <aside className="hidden w-60 flex-col border-r border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-950 md:flex">
      <div className="flex h-16 items-center gap-2 border-b border-gray-200 px-5 dark:border-gray-800">
        <span className="text-lg font-bold text-gray-900 dark:text-white">{appName}</span>
      </div>

      <nav aria-label="Navigation principale" className="flex-1 overflow-auto p-3">
        <ul className="space-y-1">
          {items.map((item) => (
            <li key={item.to}>
              <NavLink
                to={item.to}
                className={({ isActive }) => `
                  flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors
                  ${isActive
                    ? 'bg-blue-50 text-blue-700 dark:bg-blue-950 dark:text-blue-300'
                    : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800'}
                `}
                aria-current={({ isActive }: { isActive: boolean }) => isActive ? 'page' : undefined}
              >
                {item.icon}
                {item.label}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>

      {user && (
        <div className="border-t border-gray-200 p-4 dark:border-gray-800">
          <div className="flex items-center gap-3">
            <div className="flex-1 truncate">
              <p className="text-sm font-medium text-gray-900 dark:text-white">{user.name}</p>
              <p className="text-xs text-gray-500">{user.email}</p>
            </div>
            <button onClick={logout} aria-label="Déconnexion" className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200">
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" />
              </svg>
            </button>
          </div>
        </div>
      )}
    </aside>
  )
}
```

---

## Header

```tsx
interface HeaderProps {
  title?: string
  actions?: React.ReactNode
}

export function Header({ title, actions }: HeaderProps) {
  return (
    <header className="flex h-16 items-center justify-between border-b border-gray-200 bg-white px-6 dark:border-gray-800 dark:bg-gray-950">
      {title && (
        <h1 className="text-xl font-semibold text-gray-900 dark:text-white">{title}</h1>
      )}
      {actions && <div className="flex items-center gap-3">{actions}</div>}
    </header>
  )
}
```

---

## PageSkeleton

Utilisé comme fallback pour le lazy loading des pages.

```tsx
export function PageSkeleton() {
  return (
    <div className="animate-pulse space-y-6 p-6">
      <div className="h-8 w-48 rounded-lg bg-gray-200 dark:bg-gray-800" />
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="h-28 rounded-xl bg-gray-200 dark:bg-gray-800" />
        ))}
      </div>
      <div className="h-64 rounded-xl bg-gray-200 dark:bg-gray-800" />
    </div>
  )
}
```
