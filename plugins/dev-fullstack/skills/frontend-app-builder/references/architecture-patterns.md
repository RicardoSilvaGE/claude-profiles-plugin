# architecture-patterns — Gabarit d'architecture React SPA (Vite + TS + Tailwind + Router + Zustand)

> Référence du skill `frontend-app-builder`. Contenu issu du SKILL.md v1.0 (refonte pattern v2 du 12.06.2026 : le SKILL.md orchestre, cette référence documente). Les versions de dépendances font foi dans `assets/package-template.json`.

## Stack du gabarit

| Technologie | Version (cf. `assets/package-template.json`) | Rôle |
|---|---|---|
| React | 18+ (`^18.3.1`) | UI library |
| Vite | 6+ (`^6.0.0`) | Build tool & dev server |
| TypeScript | 5+ strict (`~5.6.0`) | Typage statique |
| Tailwind CSS | 4+ (`^4.0.0`) | Utility-first styling |
| React Router | 6+ | Client-side routing |
| Zustand | 4+ | State management global |
| Axios / fetch | — | HTTP client |

### Installation de base

```bash
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install react-router-dom zustand axios
npm install -D tailwindcss @tailwindcss/vite
```

### Configuration Vite (vite.config.ts)

```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import path from 'path'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### Configuration TypeScript

Partir de `assets/tsconfig-template.json`. Les points non négociables :

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "paths": { "@/*": ["./src/*"] }
  }
}
```

### Configuration Tailwind (src/index.css)

```css
@import "tailwindcss";
```

## Architecture de fichiers

Chaque app suit cette structure. L'objectif est la séparation des responsabilités : chaque dossier a un rôle clair et ne déborde pas sur les autres.

```
src/
├── main.tsx                  ← Point d'entrée, monte le RouterProvider
├── index.css                 ← Tailwind + design tokens custom
├── App.tsx                   ← Layout principal (shell + outlet)
│
├── routes/                   ← Configuration du routing
│   └── index.tsx             ← createBrowserRouter, toutes les routes
│
├── pages/                    ← Composants page (1 par route)
│   ├── Dashboard.tsx
│   ├── Login.tsx
│   ├── Settings.tsx
│   └── NotFound.tsx
│
├── components/               ← Composants réutilisables
│   ├── ui/                   ← Primitives UI (Button, Input, Card, Modal...)
│   ├── layout/               ← Shell, Sidebar, Header, Footer
│   └── features/             ← Composants métier (UserCard, ProjectList...)
│
├── hooks/                    ← Custom hooks
│   ├── useAuth.ts
│   └── useApi.ts
│
├── stores/                   ← Zustand stores
│   ├── authStore.ts
│   └── appStore.ts
│
├── services/                 ← Couche API
│   ├── api.ts                ← Instance Axios configurée
│   └── authService.ts
│
├── types/                    ← Types TypeScript partagés
│   ├── api.ts
│   └── models.ts
│
└── utils/                    ← Fonctions utilitaires pures
    ├── formatters.ts
    └── validators.ts
```

### Pourquoi cette structure ?

- **pages/** contient uniquement les composants montés par le router — un fichier = une route. Cela rend la navigation dans le code prévisible.
- **components/ui/** regroupe les primitives du design system. Ces composants ne doivent jamais contenir de logique métier ni d'appels API.
- **stores/** est séparé de **hooks/** parce que les stores Zustand ont leur propre lifecycle et sont testables indépendamment.
- **services/** encapsule tous les appels réseau. Aucun `fetch` ou `axios` ne doit apparaître directement dans un composant.

## Routing (React Router v6+)

Utiliser le pattern Data Router avec `createBrowserRouter` pour bénéficier des loaders et actions.

### Configuration (src/routes/index.tsx)

```tsx
import { createBrowserRouter, Navigate } from 'react-router-dom'
import App from '@/App'
import { ProtectedRoute } from '@/components/layout/ProtectedRoute'
import Dashboard from '@/pages/Dashboard'
import Login from '@/pages/Login'
import Settings from '@/pages/Settings'
import NotFound from '@/pages/NotFound'

export const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      { index: true, element: <Navigate to="/dashboard" replace /> },
      {
        element: <ProtectedRoute />,
        children: [
          { path: 'dashboard', element: <Dashboard /> },
          { path: 'settings', element: <Settings /> },
        ],
      },
      { path: 'login', element: <Login /> },
      { path: '*', element: <NotFound /> },
    ],
  },
])
```

### Point d'entrée (src/main.tsx)

```tsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { router } from '@/routes'
import './index.css'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>,
)
```

### Layout principal (src/App.tsx)

```tsx
import { Outlet } from 'react-router-dom'
import { Sidebar } from '@/components/layout/Sidebar'
import { Header } from '@/components/layout/Header'
import { useAuthStore } from '@/stores/authStore'

export default function App() {
  const isAuthenticated = useAuthStore((s) => s.isAuthenticated)

  if (!isAuthenticated) return <Outlet />

  return (
    <div className="flex h-screen bg-gray-50 dark:bg-gray-950">
      <Sidebar />
      <div className="flex flex-1 flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-auto p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
```

### Lazy loading (pour apps > 5 pages)

```tsx
import { lazy, Suspense } from 'react'

const Dashboard = lazy(() => import('@/pages/Dashboard'))
const Settings = lazy(() => import('@/pages/Settings'))

// Dans le router :
{ path: 'dashboard', element: <Suspense fallback={<PageSkeleton />}><Dashboard /></Suspense> }
```

## State Management (Zustand)

Zustand est choisi pour sa simplicité et son absence de boilerplate. Chaque "domaine" de l'app a son propre store.

### Conventions

- Un store = un fichier dans `stores/`
- Nommage : `use[Domain]Store` (ex: `useAuthStore`, `useProjectStore`)
- Typer l'état ET les actions dans une interface unique
- Utiliser des selectors granulaires pour éviter les re-renders inutiles

### Auth Store (src/stores/authStore.ts)

```typescript
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface User {
  id: string
  email: string
  name: string
  role: 'admin' | 'user'
}

interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
  // Actions
  login: (user: User, token: string) => void
  logout: () => void
  updateUser: (updates: Partial<User>) => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,

      login: (user, token) =>
        set({ user, token, isAuthenticated: true }),

      logout: () =>
        set({ user: null, token: null, isAuthenticated: false }),

      updateUser: (updates) =>
        set((state) => ({
          user: state.user ? { ...state.user, ...updates } : null,
        })),
    }),
    { name: 'auth-storage' }
  )
)
```

### Pattern pour store métier

```typescript
import { create } from 'zustand'

interface ProjectState {
  projects: Project[]
  isLoading: boolean
  error: string | null
  // Actions
  setProjects: (projects: Project[]) => void
  setLoading: (loading: boolean) => void
  setError: (error: string | null) => void
  addProject: (project: Project) => void
  removeProject: (id: string) => void
}

export const useProjectStore = create<ProjectState>((set) => ({
  projects: [],
  isLoading: false,
  error: null,

  setProjects: (projects) => set({ projects, error: null }),
  setLoading: (isLoading) => set({ isLoading }),
  setError: (error) => set({ error, isLoading: false }),
  addProject: (project) =>
    set((s) => ({ projects: [...s.projects, project] })),
  removeProject: (id) =>
    set((s) => ({ projects: s.projects.filter((p) => p.id !== id) })),
}))
```

## Couche API (Services)

Toute communication réseau passe par la couche services. Cela centralise la gestion des tokens, des erreurs, et du retry.

### Instance Axios (src/services/api.ts)

```typescript
import axios, { AxiosError, InternalAxiosRequestConfig } from 'axios'
import { useAuthStore } from '@/stores/authStore'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001/api'

export const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 15_000,
  headers: { 'Content-Type': 'application/json' },
})

// Intercepteur : injecte le token automatiquement
api.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const token = useAuthStore.getState().token
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Intercepteur : gère les erreurs globalement
api.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout()
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)
```

### Pattern de service (src/services/authService.ts)

```typescript
import { api } from './api'

interface LoginPayload {
  email: string
  password: string
}

interface LoginResponse {
  user: { id: string; email: string; name: string; role: 'admin' | 'user' }
  token: string
}

export const authService = {
  login: (payload: LoginPayload) =>
    api.post<LoginResponse>('/auth/login', payload).then((r) => r.data),

  logout: () =>
    api.post('/auth/logout'),

  me: () =>
    api.get<LoginResponse['user']>('/auth/me').then((r) => r.data),

  refreshToken: () =>
    api.post<{ token: string }>('/auth/refresh').then((r) => r.data),
}
```

### Hook API générique (src/hooks/useApi.ts)

```typescript
import { useState, useCallback } from 'react'

interface UseApiOptions<T> {
  onSuccess?: (data: T) => void
  onError?: (error: string) => void
}

export function useApi<T>(
  apiCall: (...args: unknown[]) => Promise<T>,
  options?: UseApiOptions<T>
) {
  const [data, setData] = useState<T | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const execute = useCallback(
    async (...args: unknown[]) => {
      setIsLoading(true)
      setError(null)
      try {
        const result = await apiCall(...args)
        setData(result)
        options?.onSuccess?.(result)
        return result
      } catch (err) {
        const message =
          err instanceof Error ? err.message : 'Erreur inattendue'
        setError(message)
        options?.onError?.(message)
        throw err
      } finally {
        setIsLoading(false)
      }
    },
    [apiCall, options]
  )

  return { data, isLoading, error, execute }
}
```

## Authentification

### Route protégée (src/components/layout/ProtectedRoute.tsx)

```tsx
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuthStore } from '@/stores/authStore'

export function ProtectedRoute() {
  const isAuthenticated = useAuthStore((s) => s.isAuthenticated)
  const location = useLocation()

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />
  }

  return <Outlet />
}
```

### Page Login (src/pages/Login.tsx)

```tsx
import { useState, type FormEvent } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '@/stores/authStore'
import { authService } from '@/services/authService'
import { Button } from '@/components/ui/Button'
import { Input } from '@/components/ui/Input'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)

  const login = useAuthStore((s) => s.login)
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: Location })?.from?.pathname || '/dashboard'

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setIsLoading(true)
    setError(null)

    try {
      const { user, token } = await authService.login({ email, password })
      login(user, token)
      navigate(from, { replace: true })
    } catch {
      setError('Email ou mot de passe incorrect')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50 dark:bg-gray-950">
      <form onSubmit={handleSubmit} className="w-full max-w-sm space-y-4 p-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
          Connexion
        </h1>

        {error && (
          <div role="alert" className="rounded-lg bg-red-50 p-3 text-sm text-red-600 dark:bg-red-950 dark:text-red-400">
            {error}
          </div>
        )}

        <Input
          label="Email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          autoFocus
        />

        <Input
          label="Mot de passe"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />

        <Button type="submit" variant="primary" fullWidth isLoading={isLoading}>
          Se connecter
        </Button>
      </form>
    </div>
  )
}
```

## Design System — Composants UI

Chaque composant UI suit les mêmes principes : typé strictement, composable via props, stylé avec Tailwind, accessible par défaut.

> Pour le détail de tous les composants (Button, Input, Card, Modal, Badge, Avatar, Table, Tabs, Toast), consulter `references/ui-components.md`.

### Button (src/components/ui/Button.tsx) — Exemple de référence

```tsx
import { type ButtonHTMLAttributes, forwardRef } from 'react'

const variants = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700 active:bg-blue-800',
  secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200 dark:bg-gray-800 dark:text-white dark:hover:bg-gray-700',
  ghost: 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800',
  danger: 'bg-red-600 text-white hover:bg-red-700 active:bg-red-800',
} as const

const sizes = {
  sm: 'h-8 px-3 text-sm',
  md: 'h-10 px-4 text-sm',
  lg: 'h-12 px-6 text-base',
} as const

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: keyof typeof variants
  size?: keyof typeof sizes
  isLoading?: boolean
  fullWidth?: boolean
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = 'primary', size = 'md', isLoading, fullWidth, className = '', children, disabled, ...props }, ref) => (
    <button
      ref={ref}
      disabled={disabled || isLoading}
      className={`
        inline-flex items-center justify-center gap-2 rounded-lg font-medium
        transition-all duration-150 focus-visible:outline-2 focus-visible:outline-offset-2
        focus-visible:outline-blue-500 disabled:pointer-events-none disabled:opacity-50
        ${variants[variant]} ${sizes[size]}
        ${fullWidth ? 'w-full' : ''}
        ${className}
      `.trim()}
      {...props}
    >
      {isLoading && (
        <svg className="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none" aria-hidden="true">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
      )}
      {children}
    </button>
  )
)

Button.displayName = 'Button'
```

## Conventions TypeScript

Ces conventions ne sont pas arbitraires — elles préviennent les bugs les plus courants dans les SPA React.

### Règles impératives

1. **`strict: true` toujours activé** — pas de `any` sauf en dernier recours documenté
2. **Interfaces pour les objets, types pour les unions/intersections** :
   ```typescript
   interface User { id: string; name: string }  // objets
   type Status = 'idle' | 'loading' | 'error'   // unions
   ```
3. **Props typées explicitement** — jamais `React.FC`, préférer les fonctions nommées :
   ```typescript
   interface CardProps { title: string; children: React.ReactNode }
   export function Card({ title, children }: CardProps) { ... }
   ```
4. **Pas de `enum`** — utiliser `as const` :
   ```typescript
   const ROLES = ['admin', 'user', 'viewer'] as const
   type Role = (typeof ROLES)[number]
   ```
5. **Générics pour les hooks et services réutilisables**
6. **Erreurs typées** dans les catch blocks :
   ```typescript
   catch (err) {
     const message = err instanceof Error ? err.message : 'Erreur inconnue'
   }
   ```

## Gestion des erreurs

### Error Boundary (src/components/layout/ErrorBoundary.tsx)

```tsx
import { Component, type ErrorInfo, type ReactNode } from 'react'

interface Props { children: ReactNode; fallback?: ReactNode }
interface State { hasError: boolean; error: Error | null }

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('ErrorBoundary caught:', error, info)
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? (
        <div className="flex h-full flex-col items-center justify-center gap-4 p-8">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            Quelque chose s'est mal passé
          </h2>
          <p className="text-gray-500">{this.state.error?.message}</p>
          <button
            onClick={() => this.setState({ hasError: false, error: null })}
            className="rounded-lg bg-blue-600 px-4 py-2 text-white hover:bg-blue-700"
          >
            Réessayer
          </button>
        </div>
      )
    }
    return this.props.children
  }
}
```

## Variables d'environnement

Utiliser le préfixe `VITE_` pour exposer les variables au client.

```bash
# .env
VITE_API_URL=http://localhost:3001/api
VITE_APP_NAME=MonApp
```

```typescript
// src/config.ts
export const config = {
  apiUrl: import.meta.env.VITE_API_URL as string,
  appName: import.meta.env.VITE_APP_NAME as string,
  isDev: import.meta.env.DEV,
  isProd: import.meta.env.PROD,
} as const
```

## Pièges courants

| Piège | Solution |
|---|---|
| `any` qui s'infiltre | Activer `noImplicitAny`, ne jamais désactiver |
| Re-renders Zustand | Toujours utiliser des selectors : `useStore(s => s.value)`, jamais `useStore()` |
| Fetch dans les composants | Toujours passer par `services/` |
| Token non envoyé | L'intercepteur Axios le gère — ne jamais l'ajouter manuellement |
| CSS global qui fuit | Tailwind + composants = pas de CSS global sauf tokens |
| Import circulaires | Les stores n'importent jamais de composants |
| Router v6 confusion | Toujours `createBrowserRouter`, jamais `<BrowserRouter>` legacy |
