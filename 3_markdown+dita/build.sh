#!/bin/bash

# Function to generate output
generate_output() {
    local FORMAT=$1
    local VARIANT=$2
    local OUTPUT_DIR="build/${FORMAT}/${VARIANT}"
    local DITAVAL="docs/resources/conditions-${VARIANT}.ditaval"
    
    mkdir -p "$OUTPUT_DIR"
    
    echo "Generating ${FORMAT} output for ${VARIANT} variant..."
    
    # Check if DITAVAL file exists
    if [[ ! -f "$DITAVAL" ]]; then
        echo "Warning: DITAVAL file $DITAVAL not found, proceeding without filtering"
        DITAVAL=""
    fi
    
    # Build the command with advanced options
    local cmd="dita --input=docs/maps/sandwich-guide.ditamap --format=${FORMAT} --output=${OUTPUT_DIR}"
    
    # Add filter if DITAVAL exists
    if [[ -n "$DITAVAL" ]]; then
        cmd="$cmd --filter=${DITAVAL}"
    fi
    
    # Add advanced parameters for better output
    cmd="$cmd -Dargs.gen.task.lbl=YES"
    cmd="$cmd -Dargs.breadcrumbs=yes"
    cmd="$cmd -Dargs.hide.parent.link=yes"
    
    if [[ "$FORMAT" == "markdown_github" ]]; then
        cmd="$cmd -Dmarkdown.flavour=GitHub"
    fi
    
    # Execute the command
    if eval "$cmd"; then
        echo "✅ Successfully generated ${FORMAT} output for ${VARIANT}"
        return 0
    else
        echo "❌ Failed to generate ${FORMAT} output for ${VARIANT}"
        return 1
    fi
}

# Check if DITA-OT is available
if ! command -v dita >/dev/null 2>&1; then
    echo "❌ DITA-OT not found in PATH"
    echo "Please install DITA-OT and add it to your PATH, or run ./demo.sh"
    exit 1
fi

echo "Using DITA-OT: $(dita --version)"

# Clean build directory
rm -rf build/

# Generate all variants
echo "Starting advanced documentation build with conditional publishing..."

build_success=true

# Generate outputs with filtering for different audiences
for format in "pdf" "html5" "markdown_github"; do
    for variant in "standard" "vegetarian"; do
        echo ""
        if ! generate_output "$format" "$variant"; then
            build_success=false
        fi
    done
done

# Also generate unfiltered version for comparison
echo ""
echo "Generating unfiltered version for comparison..."
if dita --input=docs/maps/sandwich-guide.ditamap --format=html5 --output=build/html5/all; then
    echo "✅ Successfully generated unfiltered version"
else
    echo "❌ Failed to generate unfiltered version"
    build_success=false
fi

echo ""
if $build_success; then
    echo "🎉 Advanced build completed successfully!"
    echo ""
    echo "📊 Conditional publishing results:"
    echo "Standard variant: $(find build/*/standard -type f 2>/dev/null | wc -l) files"
    echo "Vegetarian variant: $(find build/*/vegetarian -type f 2>/dev/null | wc -l) files"
    echo "Unfiltered version: $(find build/html5/all -type f 2>/dev/null | wc -l) files"
else
    echo "⚠️  Build completed with some errors"
fi

echo ""
echo "📁 Generated files:"
find build/ -type f | head -15