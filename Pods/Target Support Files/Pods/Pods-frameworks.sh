#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  else
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  fi

  local destination="${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries
  local basename
  basename="$(basename "$1" | sed -E s/\\..+// && exit ${PIPESTATUS[0]})"
  local swift_runtime_libs
  swift_runtime_libs=$(xcrun otool -LX "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${basename}.framework/${basename}" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
  for lib in $swift_runtime_libs; do
    echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
    rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
    code_sign_if_enabled "${destination}/${lib}"
  done
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements \"$1\""
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework 'Pods/AFNetworking.framework'
  install_framework 'Pods/AFOAuth2Manager.framework'
  install_framework 'Pods/BMASliders.framework'
  install_framework 'Pods/CBZSplashView.framework'
  install_framework 'Pods/CRToast.framework'
  install_framework 'Pods/CZPicker.framework'
  install_framework 'Pods/DZNEmptyDataSet.framework'
  install_framework 'Pods/EAIntroView.framework'
  install_framework 'Pods/EARestrictedScrollView.framework'
  install_framework 'Pods/EasyMapping.framework'
  install_framework 'Pods/JDStatusBarNotification.framework'
  install_framework 'Pods/KVNProgress.framework'
  install_framework 'Pods/LMDropdownView.framework'
  install_framework 'Pods/MCSwipeTableViewCell.framework'
  install_framework 'Pods/MagicalRecord.framework'
  install_framework 'Pods/NYTPhotoViewer.framework'
  install_framework 'Pods/PKYStepper.framework'
  install_framework 'Pods/SDWebImage.framework'
  install_framework 'Pods/SKKeyboardResigner.framework'
  install_framework 'Pods/TOCropViewController.framework'
  install_framework 'Pods/UICKeyChainStore.framework'
  install_framework 'Pods/XLPagerTabStrip.framework'
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework 'Pods/AFNetworking.framework'
  install_framework 'Pods/AFOAuth2Manager.framework'
  install_framework 'Pods/BMASliders.framework'
  install_framework 'Pods/CBZSplashView.framework'
  install_framework 'Pods/CRToast.framework'
  install_framework 'Pods/CZPicker.framework'
  install_framework 'Pods/DZNEmptyDataSet.framework'
  install_framework 'Pods/EAIntroView.framework'
  install_framework 'Pods/EARestrictedScrollView.framework'
  install_framework 'Pods/EasyMapping.framework'
  install_framework 'Pods/JDStatusBarNotification.framework'
  install_framework 'Pods/KVNProgress.framework'
  install_framework 'Pods/LMDropdownView.framework'
  install_framework 'Pods/MCSwipeTableViewCell.framework'
  install_framework 'Pods/MagicalRecord.framework'
  install_framework 'Pods/NYTPhotoViewer.framework'
  install_framework 'Pods/PKYStepper.framework'
  install_framework 'Pods/SDWebImage.framework'
  install_framework 'Pods/SKKeyboardResigner.framework'
  install_framework 'Pods/TOCropViewController.framework'
  install_framework 'Pods/UICKeyChainStore.framework'
  install_framework 'Pods/XLPagerTabStrip.framework'
fi
