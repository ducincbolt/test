miningpubkeys_str=""
for FILE in ./keychains/*.json
do
        echo "Processing for file $FILE"
        for (( i = 0; i < 100; i++ ))
        do
                mining_pubkey=$(jq -r .Accounts[$i].ValidatorPublicKey $FILE)
                if [[ -z "${miningpubkeys_str}" ]] ; then
                        miningpubkeys_str=$mining_pubkey
                else
                        miningpubkeys_str="$miningpubkeys_str","$mining_pubkey"
                fi
        done
done

echo "mining keys string: $miningpubkeys_str"
