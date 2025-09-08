# Single-sourcing with AsciiDoc
This project demonstrates how to single-source content using AsciiDoc. The main content files are located in the `docs` directory, and you can see examples of how to import and reuse components across different AsciiDoc files.

```adoc
include::_safety-notice.adoc[]
include::_recipe-variations.adoc[preference=standard]
include::_recipe-variations.adoc[preference=vegetarian]
```

`include::_safety-notice.adoc[]` and `include::_recipe-variations.adoc[]` are reusable components defined in separate AsciiDoc files. `include::_safety-notice.adoc[]` contains a static safety notice about food handling, while `include::_recipe-variations.adoc[]` is a component that takes a `preference` attribute to render different sandwich recipes based on the user's choice.

This allows us to maintain consistency and reduce redundancy in our documentation.

## Generating PDF

To generate a PDF version of the sandwich guide, you can use the `asciidoctor-pdf` tool. Below is an example command to convert the main AsciiDoc file into a PDF, applying a custom theme for styling.

```bash
asciidoctor-pdf docs/modules/ROOT/pages/perfect-sandwich.adoc \
  -a pdf-theme=theme/pdf-theme.yml \
  -o build/pdf/sandwich-guide.pdf
```

## Generating HTML with Antora

To generate an HTML version of the sandwich guide using Antora, you can use the following command. This will build the site and output the HTML files to the specified directory.

1. Install Antora dependencies:

   ```bash
   npm install
   ```

2. Run Antora to generate the site:

   ```bash
   antora antora-playbook.yml
   ```