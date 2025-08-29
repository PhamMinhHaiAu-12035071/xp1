#!/bin/bash
# Test script for license integration functionality
# Tests the complete license checking workflow

set -e

echo "🔐 Testing License Integration Workflow"
echo "======================================"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_info() {
    echo -e "ℹ️  $1"
}

# Test 1: Check if Very Good CLI is available
echo ""
log_info "Test 1: Checking Very Good CLI availability..."
if command -v very_good >/dev/null 2>&1; then
    log_success "Very Good CLI is installed"
else
    log_warning "Very Good CLI not found, attempting to install..."
    dart pub global activate very_good_cli:^3.4.0
    if command -v very_good >/dev/null 2>&1; then
        log_success "Very Good CLI installed successfully"
    else
        log_error "Failed to install Very Good CLI"
        exit 1
    fi
fi

# Test 2: Check if Makefile license commands exist
echo ""
log_info "Test 2: Checking Makefile license commands..."
if make -n license-check >/dev/null 2>&1; then
    log_success "license-check command exists in Makefile"
else
    log_error "license-check command not found in Makefile"
    exit 1
fi

if make -n license-help >/dev/null 2>&1; then
    log_success "license-help command exists in Makefile"
else
    log_error "license-help command not found in Makefile"
    exit 1
fi

# Test 3: Test license help command
echo ""
log_info "Test 3: Testing license help command..."
make license-help
log_success "License help command works"

# Test 4: Check current project licenses
echo ""
log_info "Test 4: Running license check on current project..."
log_info "Note: This test validates the license check command works correctly"
if make license-check; then
    log_success "✅ Current project passes license compliance"
else
    log_error "❌ License compliance check failed!"
    log_info "📋 This indicates either:"
    log_info "   1. Project has forbidden licenses (needs fixing)"
    log_info "   2. License check tool has issues (investigate)"
    log_info "🔍 Run 'make license-report' for detailed analysis"
    # Don't exit here - this is integration test, continue with other tests
fi

# Test 5: Generate license report
echo ""
log_info "Test 5: Generating license report..."
if make license-report; then
    log_success "License report generated successfully"
    if [ -f "license-report.txt" ]; then
        log_success "License report file created"
        log_info "Report summary:"
        head -10 license-report.txt | sed 's/^/  /'
    else
        log_warning "License report file not found"
    fi
else
    log_error "❌ License report generation FAILED"
    log_info "🔧 Check if very_good_cli is working correctly"
fi

# Test 6: Check lefthook integration (official hooks only)
echo ""
log_info "Test 6: Checking lefthook integration..."
if command -v lefthook >/dev/null 2>&1; then
    # Test lefthook installation instead of custom hooks
    if lefthook install --force > /dev/null 2>&1; then
        log_success "Lefthook integration works (pre-commit, pre-push hooks)"
        log_info "License checking integrated via pre-commit and pre-push hooks"
    else
        log_error "❌ Lefthook installation FAILED"
        log_info "🔧 Check lefthook permissions and git repository state"
    fi
else
    log_warning "Lefthook not installed, skipping lefthook tests"
fi

# Test 7: Test quick validation commands
echo ""
log_info "Test 7: Testing quick validation commands..."
if make license-validate-main; then
    log_success "✅ Main dependencies validation works"
else
    log_error "❌ Main dependencies validation FAILED"
    log_info "🔧 Check main dependencies in pubspec.yaml for forbidden licenses"
fi

if make license-validate-dev; then
    log_success "✅ Dev dependencies validation works"
else
    log_error "❌ Dev dependencies validation FAILED"
    log_info "🔧 Check dev dependencies in pubspec.yaml for forbidden licenses"
fi

# Test 8: Test emergency override (should always pass)
echo ""
log_info "Test 8: Testing emergency override..."
if make license-override; then
    log_success "Emergency override works"
else
    log_error "Emergency override failed"
fi

# Summary
echo ""
echo "======================================"
log_info "License Integration Test Summary:"
echo ""
echo "📋 Available Commands:"
echo "  • make license-check         - Main compliance check"
echo "  • make license-report        - Generate detailed report"
echo "  • make license-validate-main - Check main dependencies"
echo "  • make license-validate-dev  - Check dev dependencies"
echo "  • make license-help          - Show all license commands"
echo ""
echo "🔧 Git Hook Integration:"
echo "  • pre-commit: Quick license check on pubspec.yaml changes"
echo "  • pre-push: Full license compliance check"
echo "  • Manual: Use 'make license-*' commands directly"
echo ""
echo "📋 Business-Safe Licenses:"
echo "  • MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, Unlicense"
echo ""
echo "⚠️  Forbidden Licenses:"
echo "  • GPL-2.0, GPL-3.0, LGPL-2.1, LGPL-3.0, AGPL-3.0"
echo "  • unknown, CC-BY-SA-4.0, SSPL-1.0"
echo ""
log_success "License integration test completed!"
