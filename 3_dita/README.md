# Single-sourcing with DITA-OT and Markdown

This repository demonstrates a complete documentation workflow that combines Markdown authoring with DITA-OT publishing capabilities to enable single-sourcing with conditional content.

## Project Structure

```
docs/
├── maps/
│   └── sandwich-guide.ditamap      # DITA map referencing Markdown files
├── topics/
│   ├── perfect-sandwich.md         # Main content with includes
│   ├── safety-notice.md            # Shared content across all variants
│   └── recipe-variations.md        # Conditional content by audience
├── resources/
│   ├── conditions-standard.ditaval  # Filter for standard audience
│   └── conditions-vegetarian.ditaval # Filter for vegetarian audience
├── build.sh                        # Build script for all variants
└── .github/
    └── workflows/
        └── dita-build.yml          # CI/CD workflow
```

## Features

- **Single-source content**: Write once in Markdown, publish multiple formats
- **Conditional publishing**: Target different audiences (standard vs vegetarian)
- **Multiple output formats**: PDF and GitHub-flavored Markdown
- **Automated builds**: GitHub Actions workflow for CI/CD
- **Content reuse**: Shared safety notices across all variants

## Usage

### Prerequisites

- Java 11 or higher
- DITA-OT 4.1.2 or compatible version

### Local Development

1. **Install DITA-OT:**
   ```bash
   curl -LO https://github.com/dita-ot/dita-ot/releases/download/4.1.2/dita-ot-4.1.2.zip
   unzip dita-ot-4.1.2.zip
   export PATH=$PATH:$PWD/dita-ot-4.1.2/bin
   ```

2. **Build all variants:**
   ```bash
   ./build.sh
   ```

3. **Build specific variant:**
   ```bash
   dita --input=docs/maps/sandwich-guide.ditamap \
        --format=pdf \
        --output=build/pdf/standard \
        --filter=docs/resources/conditions-standard.ditaval
   ```

### Output Structure

After running the build, you'll find:

```
build/
├── pdf/
│   ├── standard/          # PDF with standard recipes
│   └── vegetarian/        # PDF with vegetarian recipes
└── markdown_github/
    ├── standard/          # Markdown with standard recipes
    └── vegetarian/        # Markdown with vegetarian recipes
```

## Content Strategy

### Conditional Content

Content is tagged with audience attributes:
- `{.audience-standard}` - Content for standard sandwich recipes
- `{.audience-vegetarian}` - Content for vegetarian recipes

### Shared Content

The safety notice appears in all variants using static includes:
```markdown
{include} safety-notice.md
```

### DITAVAL Filtering

- `conditions-standard.ditaval`: Includes standard, excludes vegetarian
- `conditions-vegetarian.ditaval`: Includes vegetarian, excludes standard

## Integration

### With Static Site Generators

The Markdown output can be post-processed for various SSGs:

**For Docusaurus:**
```bash
# Add frontmatter to generated Markdown files
echo "---\ntitle: Sandwich Guide\n---\n" > frontmatter.txt
cat frontmatter.txt build/markdown_github/standard/perfect-sandwich.md > final.md
```

**For Jekyll/Hugo:**
```bash
# Similar frontmatter processing for other SSGs
```

### CI/CD Integration

The GitHub Actions workflow automatically:
1. Sets up Java and DITA-OT
2. Runs the build script
3. Uploads artifacts for download
4. Can be extended to deploy to hosting platforms

## Testing

Verify the implementation works correctly:

1. **Content separation**: Check that standard builds contain only meat recipes
2. **Content inclusion**: Verify vegetarian builds contain only plant-based recipes  
3. **Shared content**: Confirm safety notices appear in both variants
4. **Format quality**: Test PDF rendering and Markdown structure

## Troubleshooting

### Common Issues

1. **Java not found**: Ensure Java 11+ is installed and in PATH
2. **DITA command not found**: Add DITA-OT bin directory to PATH
3. **Build failures**: Check that all referenced files exist
4. **XML validation**: Ensure DITAVAL files have correct syntax

### Debug Commands

```bash
# Test DITA-OT installation
dita --version

# Validate DITA map
dita --input=docs/maps/sandwich-guide.ditamap --format=xhtml --output=test/

# Check file references
find docs/ -name "*.md" -exec echo "File: {}" \; -exec head -5 {} \;
```

This implementation provides a complete foundation for docs-as-code workflows combining the authoring simplicity of Markdown with the powerful conditional publishing capabilities of DITA-OT.