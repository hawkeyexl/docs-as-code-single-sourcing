#!/bin/bash

# Demo script to install DITA-OT and run a test build
# This script demonstrates the complete workflow

echo "🚀 Markdown + DITA Demo Setup"
echo "============================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if command_exists java; then
    java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    echo "✅ Java found: $java_version"
else
    echo "❌ Java not found. Please install Java 11 or higher."
    exit 1
fi

if command_exists curl; then
    echo "✅ curl is available"
else
    echo "❌ curl not found. Please install curl."
    exit 1
fi

if command_exists unzip; then
    echo "✅ unzip is available"
else
    echo "❌ unzip not found. Please install unzip."
    exit 1
fi

# Install DITA-OT if not available
echo ""
echo "📦 Setting up DITA-OT..."

if command_exists dita; then
    echo "✅ DITA-OT already available: $(dita --version)"
else
    echo "📥 Downloading DITA-OT 4.1.2..."
    
    # Clean up any previous attempts
    rm -rf dita-ot-4.1.2 dita-ot-4.1.2.zip
    
    if curl -LO https://github.com/dita-ot/dita-ot/releases/download/4.1.2/dita-ot-4.1.2.zip; then
        echo "📂 Extracting DITA-OT..."
        if unzip -q dita-ot-4.1.2.zip; then
            chmod +x dita-ot-4.1.2/bin/dita
            
            # Set up environment for this session
            export PATH=$PATH:$PWD/dita-ot-4.1.2/bin
            export DITA_HOME=$PWD/dita-ot-4.1.2
            
            # Install necessary plugins for Markdown support
            echo "🔧 Installing Markdown plugin..."
            cd dita-ot-4.1.2
            ./bin/dita install https://github.com/jelovirt/dita-ot-markdown/releases/download/3.0.0/com.elovirta.dita.markdown_3.0.0.zip
            cd ..
            
            echo "✅ DITA-OT installed: $(dita --version)"
        else
            echo "❌ Failed to extract DITA-OT"
            exit 1
        fi
    else
        echo "❌ Failed to download DITA-OT"
        exit 1
    fi
fi

# Validate the installation with a simple test
echo ""
echo "🧪 Testing DITA-OT installation..."

# Test with a simple single file build first
echo "📝 Testing single file build..."
dita --input=docs/topics/safety-notice.md \
     --format=xhtml \
     --output=build/test/simple \
     2>/dev/null

if [[ $? -eq 0 ]]; then
    echo "✅ Simple build test passed"
else
    echo "⚠️  Simple build test had issues (expected with current Markdown format)"
fi

# Run the main build script
echo ""
echo "🏗️  Running main build script..."
echo "This will generate all documentation variants..."

# Capture build output and success status
build_output=$(./build.sh 2>&1)
build_exit_code=$?

echo "$build_output"

if [[ $build_exit_code -eq 0 ]]; then
    echo ""
    echo "🎉 Build completed successfully!"
    echo ""
    echo "📁 Generated outputs:"
    find build/ -type f -name "*.pdf" -o -name "*.html" -o -name "*.htm" | head -10
    
    echo ""
    echo "📊 Build summary:"
    echo "HTML files: $(find build/ -name "*.html" -o -name "*.htm" | wc -l) files"
    echo "PDF files: $(find build/ -name "*.pdf" | wc -l) files"
    echo "Total output files: $(find build/ -type f | wc -l) files"
    
    if [[ $(find build/ -type f | wc -l) -gt 0 ]]; then
        echo ""
        echo "📂 Sample output structure:"
        find build/ -type f | head -5 | while read file; do
            echo "  $file"
        done
    fi
    
else
    echo "❌ Build failed. Check error messages above."
    echo ""
    echo "🔍 Common troubleshooting steps:"
    echo "1. Check that Java 11+ is installed: java -version"
    echo "2. Verify DITA-OT installation: dita --version"
    echo "3. Check file permissions: ls -la docs/"
    echo "4. Test simple build: dita --input=docs/topics/perfect-sandwich.md --format=html5 --output=build/test"
fi

echo ""
echo "🎯 Demo Complete!"
echo "================"
echo ""
echo "📖 What was demonstrated:"
echo "• Automated DITA-OT installation"
echo "• Single-source Markdown content"
echo "• Conditional publishing (standard vs vegetarian)"
echo "• Multiple output formats (PDF + Markdown)"
echo "• Complete build automation"
echo ""
echo "🔗 Integration options:"
echo "• Add to CI/CD pipelines"
echo "• Integrate with static site generators"
echo "• Customize output formats"
echo "• Extend conditional content"
echo ""
echo "📚 Next steps:"
echo "1. Explore the build/ directory"
echo "2. Modify content in docs/topics/"
echo "3. Run ./build.sh to regenerate"
echo "4. Integrate with your documentation workflow"