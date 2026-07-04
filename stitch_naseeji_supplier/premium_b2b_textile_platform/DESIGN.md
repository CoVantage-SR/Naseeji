---
name: Premium B2B Textile Platform
colors:
  surface: '#fbf8ff'
  surface-dim: '#d9d9e6'
  surface-bright: '#fbf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f2ff'
  surface-container: '#ededfa'
  surface-container-high: '#e7e7f4'
  surface-container-highest: '#e2e1ef'
  on-surface: '#191b24'
  on-surface-variant: '#434656'
  inverse-surface: '#2e303a'
  inverse-on-surface: '#f0effd'
  outline: '#747688'
  outline-variant: '#c4c5d9'
  surface-tint: '#124af0'
  primary: '#0040e0'
  on-primary: '#ffffff'
  primary-container: '#2e5bff'
  on-primary-container: '#efefff'
  inverse-primary: '#b8c3ff'
  secondary: '#006b5f'
  on-secondary: '#ffffff'
  secondary-container: '#72f8e4'
  on-secondary-container: '#007165'
  tertiary: '#993100'
  on-tertiary: '#ffffff'
  tertiary-container: '#c24100'
  on-tertiary-container: '#ffece6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dde1ff'
  primary-fixed-dim: '#b8c3ff'
  on-primary-fixed: '#001356'
  on-primary-fixed-variant: '#0035be'
  secondary-fixed: '#72f8e4'
  secondary-fixed-dim: '#51dbc8'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005047'
  tertiary-fixed: '#ffdbcf'
  tertiary-fixed-dim: '#ffb59b'
  on-tertiary-fixed: '#380d00'
  on-tertiary-fixed-variant: '#812800'
  background: '#fbf8ff'
  on-background: '#191b24'
  surface-variant: '#e2e1ef'
typography:
  display-lg:
    fontFamily: IBM Plex Sans
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: IBM Plex Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: IBM Plex Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: IBM Plex Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: IBM Plex Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: IBM Plex Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: IBM Plex Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: IBM Plex Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-lg:
    fontFamily: IBM Plex Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-sm:
    fontFamily: IBM Plex Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 32px
  max-width: 1440px
---

## Brand & Style

The brand personality is **trustworthy, efficient, high-end, and smart**. It positions itself as an essential bridge between suppliers and smart factories. The visual language conveys reliability through structured layouts, while maintaining a premium "textile" feel through smooth transitions and high-quality finishes.

The design style follows a **Modern Corporate** approach, heavily influenced by **Material Design 3 (M3)** principles. It utilizes clean surfaces, intentional whitespace, and a high-contrast color palette to ensure clarity in complex B2B workflows. The aesthetic is refined, professional, and optimized for high-performance cross-platform environments like Flutter.

## Colors

The palette is designed for high-end B2B utility. **Deep Indigo** serves as the primary anchor, conveying authority and technical precision. **Teal** provides a secondary professional touch, often used for financial or growth-related metrics. **Orange** is reserved for high-impact accents and call-to-actions to ensure they stand out against the cooler primary tones.

In **Dark Mode**, surfaces transition to **Dark Gray (#111827)**, using subtle tonal shifts rather than pure black to maintain depth. Functional colors (Success, Warning, Error) follow standard semantic patterns but are adjusted for high legibility against both light and dark backgrounds.

## Typography

The system utilizes **IBM Plex Sans** (specifically supporting the Arabic script variant) to ensure a seamless bilingual experience. The typeface is technical yet approachable, mirroring the platform's smart industrial nature.

- **Headlines:** Use **Bold (700)** weights for maximum impact and clear hierarchy in dashboard headers.
- **Body Text:** Uses **Medium (500)** weights for standard content to ensure high legibility on high-density screens.
- **Interactive Elements:** Buttons and interactive labels use **SemiBold (600)** to provide a clear affordance of "tappability" and importance.

## Layout & Spacing

This design system employs a **Fluid Grid** model based on a 4px baseline unit, ensuring pixel-perfect alignment in Flutter. 

- **Desktop:** A 12-column grid with 24px gutters. Content is typically housed in a centered container with a max-width of 1440px.
- **Tablet:** An 8-column grid with 24px gutters.
- **Mobile:** A 4-column grid with 16px gutters and 16px side margins.

Spacing follows a geometric progression (4, 8, 12, 16, 24, 32, 48, 64) to create a consistent vertical rhythm. Components like data tables or inventory lists should use "Compact" spacing (8-12px), while marketing or landing pages use "Relaxed" spacing (32-48px).

## Elevation & Depth

Visual hierarchy is established through **Tonal Layers** and **Ambient Shadows**, consistent with Material 3’s concept of "Color as Elevation."

- **Level 0 (Background):** #F8FAFC. The base layer.
- **Level 1 (Cards/Surfaces):** White background with a very soft, diffused shadow (`blur: 20px, y: 4px, color: rgba(0,0,0, 0.04)`).
- **Level 2 (Active/Hover):** Increased shadow depth (`blur: 30px, y: 8px, color: rgba(0,0,0, 0.08)`) and a subtle 1px inner border in Primary light.
- **Overlays (Modals/Menus):** Use a high-diffusion shadow and a 20% backdrop blur (Glassmorphism) to keep the user oriented within the platform context.

## Shapes

The shape language is sophisticated and modern, moving away from sharp industrial corners toward **Soft Rounded** forms.

- **Small Components (Buttons, Chips):** 12px - 16px radius.
- **Medium Components (Input Fields, Dropdowns):** 12px radius.
- **Large Components (Cards, Modals):** 18px to 24px radius to create a "premium" tactile feel.
- **Standard Outlines:** Use a 1px width for outlined icons and input borders to maintain a clean, airy appearance.

## Components

### Buttons
- **Primary:** Filled with Deep Indigo, SemiBold white text. Use a subtle gradient (Deep Indigo to a slightly lighter blue) for a premium finish.
- **Secondary:** Outlined with 1px Teal border and Teal text.
- **Ghost:** No background, Primary or Neutral text, used for less prominent actions.

### Cards
- **Premium Card:** White surface, 20px border radius, soft ambient shadow. Include a 4px top-accent border in Primary or Secondary color to categorize content.

### Input Fields
- Outlined style with 12px corner radius. 
- **Inactive:** Light gray border (#E2E8F0). 
- **Active:** 2px Deep Indigo border with a faint primary-colored glow.

### Chips & Badges
- Used for "Status" (In Transit, Delivered, Low Stock). 
- Rounded (Pill-shaped) with low-opacity background tints of the semantic color (e.g., Success green at 10% opacity) and dark colored text.

### Navigation
- **Bottom Navigation (Mobile):** M3 style with active indicator "pills."
- **Side Rail (Desktop):** Collapsible navigation with modern outlined icons and semi-bold labels.