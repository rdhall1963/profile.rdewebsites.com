# Copilot Instructions for Web Author Profile

## Architecture Overview
This is a static HTML/CSS personal profile website with a dark theme design system. The project follows a semantic HTML structure with accessibility considerations and modern CSS Grid/Flexbox layouts.

## Design System Patterns
- **CSS Custom Properties**: All colors defined in `:root` as `--bg`, `--panel`, `--ink`, `--accent`, `--accent-2`
- **Typography Hierarchy**: Three distinct font families serve specific purposes:
  - `Inter` (Base): Body text and general UI
  - `Merriweather` (Headings): For `h1`, `h2` elements and emphasis
  - `Source Code Pro` (Footer): Monospace for contact information
- **Card Pattern**: Consistent `.card` class provides standardized spacing, borders, and shadows for content sections

## Layout Conventions
- **CSS Grid First**: Primary layout uses CSS Grid (`display: grid`) for responsive design
  - `.intro` section: 2-column grid with fixed avatar width (140px)
  - `.hobbies-list`: Auto-fit grid with minimum 220px columns
- **Responsive Approach**: Uses `min()` function for width constraints (`width: min(920px, 92%)`)
- **Fixed Background**: Background image with `background-attachment: fixed` for parallax effect

## Accessibility Standards
- **Semantic HTML**: Proper use of `<main>`, `<section>`, `<header>`, `<footer>`
- **ARIA Labels**: All sections have `aria-labelledby` pointing to heading IDs
- **Screen Reader Support**: `.sr-only` class for visually hidden but accessible content
- **Image Fallbacks**: `onerror` attribute provides graceful degradation for missing images

## File Structure Rules
- `Profile.html`: Main document, uses lowercase linking to `style.css` (not `Style.css`)
- External assets: Images expected in `img/` directory, fallback to Picsum placeholder
- Google Fonts: Three families loaded with specific weights in single request

## Content Structure Requirements
- **Contact Section**: Footer must include email and social links with `target="_blank" rel="noopener"`
- **Table Requirements**: Schedule table needs minimum 3 rows × 3 columns with proper `<thead>`/`<tbody>`
- **List Requirements**: Hobbies section requires minimum 3 items in unordered list

## Styling Conventions
- **Dark Theme First**: All color choices assume dark background (`#0f172a`)
- **Border Radius**: Consistent 10-12px radius for cards and UI elements
- **Color Usage**: `--accent` (blue) for primary elements, `--accent-2` (amber) for secondary emphasis
- **Box Model**: Cards demonstrate margin/padding/border relationships for educational purposes

## External Dependencies
- Google Fonts API for typography
- Unsplash for background imagery
- Graceful fallbacks for all external resources