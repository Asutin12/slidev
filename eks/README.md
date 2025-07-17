# EKS Presentation with Slidev

This is a presentation project about EKS (Amazon Elastic Kubernetes Service), built with [Slidev](https://sli.dev/).

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [Bun](https://bun.sh/)

### Setup

1.  **Install dependencies:**

    ```bash
    bun install
    ```

2.  **Start the development server:**

    ```bash
    bun dev
    ```

    The presentation will be available at `http://localhost:3030`.

## Usage

### Editing Slides

Edit the `slides.md` file to make changes to the presentation content. The browser will automatically reload to reflect the changes.

### Building for Production

To build the presentation as a static website:

```bash
bun run build
```

The output will be generated in the `dist/` directory.

### Exporting as PDF

To export the presentation as a PDF file:

```bash
bun run export
```

The output will be saved as `slides.pdf`.

## Project Structure

-   `slides.md`: The main content of your slides in Markdown format.
-   `components/`: Directory for custom Vue components.
-   `assets/`: Directory for static assets like images.
-   `style.css`: Custom CSS styles for your presentation.
-   `package.json`: Project metadata and dependencies.

## Deployment

This project can be deployed to services like Netlify or Vercel. Configuration files (`netlify.toml` and `vercel.json`) are included.

## Learn More

For more information about Slidev, please visit the [official documentation](https://sli.dev/).