#!/bin/bash

# Test script for Skynet Kubernetes Manifests
# Tests YAML validation, Kubernetes resource validation, and Helm templates

set -e

echo "🧪 Testing Skynet Kubernetes Manifests Structure"
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        exit 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# Test 1: YAML Syntax Validation
echo
print_info "Testing YAML syntax validation..."
yamllint argocd-manifests/ helm-values/ app-manifests/ --format parsable | grep -v "missing document start" || true
print_status "YAML syntax validation completed"

# Test 2: Kubernetes Resource Validation
echo
print_info "Testing Kubernetes resource validation..."

# Test ArgoCD Applications
for env in dev staging prod; do
    print_info "Validating $env environment..."
    kubectl apply --dry-run=client -f argocd-manifests/$env/app-of-apps.yaml > /dev/null
    print_status "App-of-Apps $env validation"
    
    kubectl apply --dry-run=client -f argocd-manifests/$env/ingress-nginx.yaml > /dev/null
    print_status "Ingress-NGINX $env validation"
    
    kubectl apply --dry-run=client -f argocd-manifests/$env/argocd-projects.yaml > /dev/null
    print_status "ArgoCD Projects $env validation"
done

# Test 3: Helm Template Validation
echo
print_info "Testing Helm template validation..."

# Test ingress-nginx values
helm template test-ingress ingress-nginx/ingress-nginx \
    --values helm-values/ingress-nginx/values-dev.yaml > /dev/null
print_status "Ingress-NGINX dev values template"

helm template test-ingress ingress-nginx/ingress-nginx \
    --values helm-values/ingress-nginx/values-prod.yaml > /dev/null
print_status "Ingress-NGINX prod values template"

# Test 4: Directory Structure Validation
echo
print_info "Testing directory structure..."

required_dirs=(
    "argocd-manifests/dev"
    "argocd-manifests/staging" 
    "argocd-manifests/prod"
    "app-manifests"
    "helm-values"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_status "Directory $dir exists"
    else
        echo -e "${RED}❌ Directory $dir missing${NC}"
        exit 1
    fi
done

# Test 5: Environment Consistency
echo
print_info "Testing environment consistency..."

for env in dev staging prod; do
    required_files=(
        "app-of-apps.yaml"
        "argocd-projects.yaml"
        "ingress-nginx.yaml"
        "observability-stack.yaml"
        "skynet-docs.yaml"
        "workload-namespaces.yaml"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "argocd-manifests/$env/$file" ]; then
            print_status "$env/$file exists"
        else
            print_warning "$env/$file missing"
        fi
    done
done

# Test 6: Git Status Check
echo
print_info "Checking git status..."
git status --porcelain | head -10
if [ -z "$(git status --porcelain)" ]; then
    print_status "Working directory clean"
else
    print_warning "Working directory has changes"
fi

echo
echo "🎉 All tests completed successfully!"
echo "Structure is ready for GitOps deployment."
