#!/bin/bash
set -e

install_rust_script_latest() {
    cargo install rust-script
}

install_rust_script_env_version() {
    cargo install rust-script --version $RUST_SCRIPT_VERSION
}

# Check if $RUST_SCRIPT_FILE_PATH has been set.
if [ -z "${RUST_SCRIPT_FILE_PATH}" ]; then
  printf "No file path provided, make sure RUST_SCRIPT_FILE_PATH is set.\n"
  exit 1
fi

# If no Rust Toolchain is present, fail the step.
if ! command -v rustup &> /dev/null; then
  printf "Rust Toolchain is not installed, exiting...\n"
  exit 1
fi

# If both envs are set, exit as it's undefined behavior.
if [ "$RUST_SCRIPT_VERSION" ] && [ "$RUST_SCRIPT_AUTO_UPDATE" = true ]; then 
    printf "Cannot set both RUST_SCRIPT_VERSION and RUST_SCRIPT_AUTO_UPDATE variables! Exiting..."
    exit 1
fi

# If rust-script is (not present OR autoupdate is enabled) AND (no custom version is set), then run cargo install with no version.
if (! command -v rust-script &> /dev/null || [ "$RUST_SCRIPT_AUTO_UPDATE" = true ]) && [ -z "$RUST_SCRIPT_VERSION" ]; then
    printf "Installing or updating rust-script...\n"
    install_rust_script_latest
elif [ "$RUST_SCRIPT_VERSION" ]; then # Otherwise install a specific version of rust-script.
    printf "Selected rust-script version is $RUST_SCRIPT_VERSION, installing...\n"
    install_rust_script_env_version
fi

rust-script --cargo-output $BITRISE_STEP_SOURCE_DIR/$RUST_SCRIPT_FILE_PATH

case "$OSTYPE" in
  darwin*)  
    envman add --key RUST_SCRIPT_CACHE_PATH --value '~/Library/Caches/rust-script'
    ;; 
  
  linux*)   
    envman add --key RUST_SCRIPT_CACHE_PATH --value '~/.cache/rust-script'
    ;;

  *)        
    printf "Cache path not supported for OS: $OSTYPE, skipping...\n\n" 
    exit 0
    ;;
esac

exit $?
