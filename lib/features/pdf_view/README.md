# PDF View Feature - Book Store

This feature provides a beautiful book store UI where users can browse and read PDF books for free.

## Features

- **Book Grid Layout**: Displays books in a responsive 2-column grid
- **Beautiful Book Cards**: Each book is displayed in an attractive card with cover image, title, and metadata
- **PDF Viewer**: Integrated PDF viewer using the `flutter_pdfview` package with automatic download from URLs
- **Loading States**: Shimmer loading effects and proper error handling
- **Responsive Design**: Uses `flutter_screenutil` for responsive layouts

## Components

### Pages
- `pdf_view.dart` - Main book store page with grid layout
- `pdf_viewer_screen.dart` - PDF viewer screen for reading books

### Widgets
- `book_card.dart` - Reusable book card widget

## Usage

The feature integrates with the existing `HomeCubit` to fetch PDF learning content:

```dart
// Fetch PDF books
cubit.getLearningList(Strings.pdf);
```

## Dependencies

- `flutter_pdfview: ^1.4.1+1` - For PDF viewing functionality
- `http: ^1.5.0` - For downloading PDF files from URLs
- `path_provider: ^2.1.5` - For accessing device storage
- `shimmer: ^3.0.0` - For loading animations
- `cached_network_image: ^3.4.1` - For efficient image loading
- `flutter_screenutil: ^5.9.3` - For responsive design

## Design Features

- **Modern UI**: Clean, modern design with rounded corners and shadows
- **Color Scheme**: Uses the app's existing color palette
- **Typography**: Sofia Sans font family for consistency
- **Gradient Backgrounds**: Beautiful gradient backgrounds for book covers
- **Free Badge**: Green "FREE" badge to indicate free books
- **PDF Icon**: Orange PDF icon to indicate file type

## Error Handling

- Loading states with shimmer effects
- Error states with retry functionality
- Empty states for when no books are available
- PDF loading errors with user-friendly messages

## Navigation

- Back button in app bar
- Tap on book cards to open PDF viewer
- Share button in PDF viewer (placeholder for future implementation)
