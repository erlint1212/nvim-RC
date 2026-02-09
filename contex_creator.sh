find . -type f \( -name "*" -o -name "*.yml" -o -name "*.yaml" \)  -not -path "*/.git/*" -not -path "*/logs/*" -not -name "nvim_context.txt" | while read f; do     echo -e "\n\n==================================================================";     echo "FILE: $f";     echo "==================================================================";     cat "$f"; done >| nvim_context.txt

