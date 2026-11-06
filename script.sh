test_case_prefix="Version"

for folder in Testcase*Diff; do
    rm -rf "$folder"
done

for folder in Testcase*; do
    version=${folder#Testcase}

    for file in ${folder}/Version*.1.txt; do
        basetemp="${file%.1.txt}"
        base="${basetemp#${folder}/}"
        file2="${basetemp}.2.txt"

        output=$(diff -u "$file" "$file2")

        if [ "$output" != "" ]; then
            mkdir -p "Testcase${version}Diff"
            diff -u "$file" "$file2" > "Testcase${version}Diff/${base}Diff.txt"
        fi
    done
done    