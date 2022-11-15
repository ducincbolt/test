
while [ $# -gt 0 ]; do
	if [[ $1 == "--"* ]]; then
		v="${1/--/}"
		declare "$v"="$2"
		shift
	fi
	shift
done

# transfer 
for (( i = $min; i < $max; i++ ))
do
	pa=$(jq -r .Accounts[$i].PaymentAddress $keychainpath)
	echo "Processing transfer for index: $i,  address: $pa"
	./cli --cache 1 --debug 1 send --privateKey $prikey --address $pa --amount 1750000000400
	sleep 30 # 30s
done

# stake
for (( i = $min; i < $max; i++ ))
do
	privateKey=$(jq -r .Accounts[$i].PrivateKey $keychainpath)
	echo "Processing staking for index: $i"
	./cli --cache 1 stake --privateKey $privateKey --rewardAddress $rewardaddr --autoReStake 1
	sleep 10 # 10s
done
