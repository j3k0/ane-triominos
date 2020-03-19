#!/bin/bash

if test ! -e temp/android/libAneTriominos.jar
then
  ant android
fi

echo '
<platform xmlns="http://ns.adobe.com/air/extension/33.1">
    <packagedDependencies>
'
for i in $(ls temp/android/*.jar | grep -- -)
do
  echo "        <packagedDependency>$(basename "$i")</packagedDependency>"
done
echo '
    </packagedDependencies>
    <packagedResources>
    </packagedResources>
</platform>
'
