
while [ $# -gt 0 ]; do
	if [[ $1 == "--"* ]]; then
		v="${1/--/}"
		declare "$v"="$2"
		shift
	fi
	shift
done

if [ ! -d "./keychains" ]
then
	mkdir keychains
else
	echo "Folder ./keychains existed"
fi

if [[ ! -f "./keychains/batch_$batch.json" ]]
then
	./cli account generate --shardID 3 --numAccounts 100 > "./keychains/batch_$batch.json"
else
	echo "File /keychains/batch_$batch.json existed"
fi

bash runnode.sh --public_ip $public_ip --chain_tag $chain_tag

