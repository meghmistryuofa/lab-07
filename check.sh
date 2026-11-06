failed=0

for folder in Testcase*/; do
    folder="${folder%/}"
    pass=1
    anydiff=0

    if [ "$folder" == "${folder%Diff}" ]; then
        num="${folder%/}"
        num="${num#Testcase}"
        difffolder="Testcase${num}Diff"

        for file in "${folder}"/Version*.1.txt; do
            basetemp="${file%.1.txt}"
            base="${basetemp#${folder}/}"
            file2="${basetemp}.2.txt"

            outfile="${difffolder}/${base}Diff.txt"

            output=$(diff -u "$file" "$file2")

            if [ "$output" != "" ]; then
                anydiff=1
                if [ ! -f "$outfile" ]; then
                    pass=0
                else
                    check=$(cat "$outfile")
                    if [ "$output" != "$check" ]; then
                        pass=0
                    fi
                fi
            else
                if [ -f "$outfile" ]; then
                    pass=0
                fi
            fi
        done

        if [ "$anydiff" -eq 0 ] && [ -d "$difffolder" ]; then
            pass=0
        fi

        if [ "$pass" == 1 ]; then
            echo "${folder}: PASS"
        else
            echo "${folder}: FAIL"
            failed=1
        fi
    fi
done

exit $failed