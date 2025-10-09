# Butchee App Blueprint

## Overview

This document outlines the features and implementation details of the Butchee application, a Flutter-based mobile app.

## Implemented Features

### Authentication

- **Login Page:**
  - Displays the Butchee logo.
  - Provides fields for email/phone and password.
  - Includes a "Login" button.
  - Offers social login options (Apple, Google, Facebook).
  - Provides a link to the registration page for new users.
  - Includes a "Forgot Password?" option.

- **Registration Page:**
  - Displays the Butchee logo within a green circle.
  - Includes fields for "Full Name", "Email", "Phone", "Password", and "Confirm Password".
  - Features a checkbox to agree to the Terms & Conditions.
  - A "Sign Up" button, which is enabled only after agreeing to the terms.
  - A link to the login page for existing users.

## Project Structure

- `lib/main.dart`: The main entry point of the application, which initializes the app and sets the `LoginPage` as the home screen.
- `lib/features/authentication/presentation/pages/login_page.dart`: The UI for the login screen.
- `lib/features/authentication/presentation/pages/register_page.dart`: The UI for the registration screen.
- `lib/core/constants/colors.dart`: Defines the color palette for the application.
- `lib/core/constants/typography.dart`: Defines the text styles for the application.
- `lib/core/widgets/custom_button.dart`: A reusable button widget.
- `lib/core/widgets/custom_textfield.dart`: A reusable text field widget.
- `assets/images/butchee_logo.svg`: The application logo.
