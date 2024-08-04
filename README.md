# Recipe App Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [App UI Overview](#app-ui-overview)
   - [Home Screen](#home-screen)
   - [Recipe Search](#recipe-search)
   - [Recipe Details](#recipe-details)
3. [Setting Up the Development Environment](#setting-up-the-development-environment)
4. [Getting Spoonacular API Key](#getting-spoonacular-api-key)
5. [Running the App in Development Mode](#running-the-app-in-development-mode)
6. [Building the Release Version using Shorebird](#building-the-release-version-using-shorebird)

## Introduction

This documentation provides an overview of the Recipe App and detailed instructions for setting up the development environment, running the app, and creating a release build using Shorebird.

## App UI Overview

### Home Screen

![Home Screen](images/home_screen.png)

The Home Screen displays a list of popular recipes fetched from the Spoonacular API. Users can scroll through the recipes and click on any recipe to view its details.

### Recipe Search

![Recipe Search](images/recipe_search.png)

The Recipe Search screen allows users to search for recipes using keywords. The search results are displayed in a list format.

### Recipe Details

![Recipe Details](images/recipe_details.png)

The Recipe Details screen provides detailed information about a selected recipe, including ingredients, instructions, and nutritional information.

## Setting Up the Development Environment

1. **Install Flutter:**
   Follow the instructions on the [Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up Flutter on your machine.

2. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-repo/recipe-app.git
   cd recipe-app
   ```

## Building the Release Version using Shorebird

### Prerequisites

- Ensure you have the Shorebird CLI installed. If not, follow the [installation guide](https://shorebird.dev/docs/cli/installation).

### Steps

### Step 1: Login to Shorebird:

```bash
shorebird login
```

### Step 2: Set Up Shorebird for Your Project:

Navigate to your project directory and run:

```bash
shorebird init
```

### Step 3: Build the Release Version

Run the following command to build the release version of your app using Shorebird:

```bash
shorebird build apk
```

### Step 4: Locate the Release Build

After the build process completes, the release APK will be available in the `build/shorebird` directory.

### Step 5: Deploy the APK

You can now deploy the APK to your desired platform or distribute it for testing.
