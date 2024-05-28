#!/bin/bash

echo "Peer ID,Peer Base64,Difficulty,Difficulty Metric,Commit16 Metric,Commit128 Metric,Commit1024 Metric,Commit65536 Metric,Proof16 Metric,Proof128 Metric,Proof1024 Metric,Proof65536 Metric,Cores,Memory,Storage,Last Seen" > manifestlist.csv

while IFS= read -r peer_id; do
    peer_id_base64=$(echo -n $peer_id | base58 -d | base64 | tr -d '\n')
    peer_manifests=$(grpcurl -plaintext localhost:8337 quilibrium.node.node.pb.NodeService.GetPeerManifests | grep -A 15 $peer_id_base64)

    peer_id=$(echo "$peer_id" | tr -d '\n' | tr -d '\r')

    difficulty=$(echo "$peer_manifests" | grep '"difficulty":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    difficulty_metric=$(echo "$peer_manifests" | grep '"difficultyMetric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    commit16_metric=$(echo "$peer_manifests" | grep '"commit16Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    commit128_metric=$(echo "$peer_manifests" | grep '"commit128Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    commit1024_metric=$(echo "$peer_manifests" | grep '"commit1024Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    commit65536_metric=$(echo "$peer_manifests" | grep '"commit65536Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    proof16_metric=$(echo "$peer_manifests" | grep '"proof16Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    proof128_metric=$(echo "$peer_manifests" | grep '"proof128Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    proof1024_metric=$(echo "$peer_manifests" | grep '"proof1024Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    proof65536_metric=$(echo "$peer_manifests" | grep '"proof65536Metric":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    cores=$(echo "$peer_manifests" | grep '"cores":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    memory=$(echo "$peer_manifests" | grep '"memory":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    storage=$(echo "$peer_manifests" | grep '"storage":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')
    last_seen=$(echo "$peer_manifests" | grep '"lastSeen":' | awk -F ': ' '{print $2}' | tr -d ',' | tr -d '\n')

    echo "$peer_id,$peer_id_base64,$difficulty,$difficulty_metric,$commit16_metric,$commit128_metric,$commit1024_metric,$commit65536_metric,$proof16_metric,$proof128_metric,$proof1024_metric,$proof65536_metric,$cores,$memory,$storage,$last_seen" >> manifestlist.csv
done < peerlist