
while [ $# -gt 0 ]; do
	if [[ $1 == "--"* ]]; then
		v="${1/--/}"
		declare "$v"="$2"
		shift
	fi
	shift
done

if [ ! -d "./data" ]
then
        mkdir -p ./data/mainnet/block
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/beacon.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard0.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard1.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard2.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard3.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard4.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard5.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard6.tar.zst
	wget -P ./data/mainnet/block https://bootstrap.incognito.org/shard7.tar.zst
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/beacon.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard0.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard1.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard2.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard3.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard4.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard5.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard6.tar.zst -C ./data/mainnet/block
	tar --use-compress-program=unzstd -xvf ./data/mainnet/block/shard7.tar.zst -C ./data/mainnet/block
else
        echo "Folder ./data existed"
fi
echo "data dir is ready!!!"

miningkeys_str=""
for FILE in ./keychains/*.json
do	
	echo "Processing for file $FILE"
	for (( i = 0; i < 100; i++ ))
	do
		mining_key=$(jq -r .Accounts[$i].MiningKey $FILE)
		if [[ -z "${miningkeys_str}" ]] ; then
			miningkeys_str=$mining_key
		else
			miningkeys_str="$miningkeys_str","$mining_key"
		fi
	done
done

echo "mining keys string: $miningkeys_str"

docker stop inc-nodes && docker rm -f inc-nodes

echo "docker run --restart=always -e NUM_INDEXER_WORKERS=0 -e TXPOOL_VERSION=0 -e GETH_PROTOCOL=https -e GETH_NAME=eth-fullnode.incognito.org -e GETH_PORT="" -e NAME="inc-nodes" -e TESTNET=false -p 9334:9334 -p 9335:9335 -p 9336:9336 -e BOOTNODE_IP=mainnet-bootnode.incognito.org:9330 -v $PWD/data:/data -e MININGKEY=$miningkeys_str -e PUBLIC_IP=$public_ip  -e NODE_PORT=9334 -e WS_PORT=9336 -e RPC_PORT=9335 -d --name inc-nodes incognitochain/incognito-fixed-nodes:$chain_tag bash /run_incognito.sh"

docker run --restart=always -e NUM_INDEXER_WORKERS=0 -e TXPOOL_VERSION=0 -e GETH_PROTOCOL=https -e GETH_NAME=eth-fullnode.incognito.org -e GETH_PORT="" -e NAME="inc-nodes" -e TESTNET=false -p 9334:9334 -p 9335:9335 -p 9336:9336 -e BOOTNODE_IP=mainnet-bootnode.incognito.org:9330 -v $PWD/data:/data -e MININGKEY=$miningkeys_str -e PUBLIC_IP=$public_ip  -e NODE_PORT=9334 -e WS_PORT=9336 -e RPC_PORT=9335 -d --name inc-nodes incognitochain/incognito-fixed-nodes:$chain_tag bash /run_incognito.sh

