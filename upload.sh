#!/bin/bash

SRC_DIR=./src
OUT_DIR=./output
rm -rf ${OUT_DIR}
mkdir "${OUT_DIR}"

find "${SRC_DIR}" -print0 | while IFS= read -r -d '' file
do
    relfile=${file/"${SRC_DIR}"/}
    relfile=${relfile/\//}
    if [ -n "${relfile}" ]; then
         if [ -d "${file}" ]; then
            mkdir "${OUT_DIR}/${relfile}"
         else
            hash=$(shasum "${file}" | cut -d' ' -f1)
            ext="${relfile##*.}"
            name="${relfile%.*}"
            cp "$file" "${OUT_DIR}/${name}.${hash}.${ext}"
         fi
      fi
done
cd "${OUT_DIR}"
aws s3 sync . s3://xtages-cdn
