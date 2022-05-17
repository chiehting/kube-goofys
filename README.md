# Shared storage with S3 backend

使用 goofys 掛載 AWS S3 Storage 至 Kubernets pod 中。

## Getting Started

參照 [kube-s3](https://github.com/freegroup/kube-s3) 概念，將元件 [s3fs](https://github.com/s3fs-fuse/s3fs-fuse) 改為 [goofys](https://github.com/kahing/goofys)。

因為 goofys 的 Benchmark 優於 s3fs，所以作替換。

### Prerequisites

Docker

```bash
bash$ docker version
Client:
 Version: 20.10.8
・・・
Server: Docker Engine - Community
 Engine:
  Version: 20.10.8
・・・
```

Helm

```bash
bash$ helm version
version.BuildInfo{Version:"v3.5.4", GitCommit:"1b5edb69df3d3a08df77c9902dc17af864ff05d1", GitTreeState:"dirty", GoVersion:"go1.16.3"}
```

## Usage

先 login container regristry 再執行 `build.sh`，會自動將 image push 至 container regristry。

```bash
bash$ docker login --username AWS --password-stdin ecr.amazonaws.com
bash$ bash build.sh
```

編輯 helm-chart 腳本，調整 values.yaml 參數：。

```bash
bash$ vim helm-chart/values.yaml
```

若要掛載多個 BUCKET 的話，AWS_S3_BUCKETS_NAME 可以用空白隔開。如下面設定 AWS S3 BUCKET 會掛載在 eks nodes 的 `/mnt/s3/bucket1`、`/mnt/s3/bucket2`、`/mnt/s3/bucket3`。

```yaml
image:
  repository: dkr.ecr.ap-southeast-1.amazonaws.com/kube-goofys
  pullPolicy: Always
  tag: "1.0.0"

env:
  - name: AWS_ACCESS_KEY_ID
    value: ""
  - name: AWS_SECRET_ACCESS_KEY
    value: ""
  - name: MOUNT_POINT
    value: "/mnt/s3"
  - name: AWS_S3_BUCKETS_NAME
    value: "bucket1 backet2 backet3"
```

完成後執行 helm install 建立 POD。

```bash
bash$ helm install kube-goofys helm-chart
NAME: kube-goofys
LAST DEPLOYED: Thu Sep 16 17:26:46 2021
NAMESPACE: dev
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Testing

編輯 testing/testing_pod.yaml，將 `volumes.[].hostPath.path` 改為掛載在 eks nodes 上的路徑，例如 `/mnt/s3/bucket1`、`/mnt/s3/bucket2`、`/mnt/s3/bucket3`。

```yaml
  volumeMounts:
  - name: s3mount
    mountPath: /var/s3:shared
volumes:
- name: s3mount
  hostPath:
    path: /mnt/s3/bucket1
```

接著執行部署，嘗試創建檔案看是否有上傳至 AWS S3 上。

```bash
bash$ kubectl apply -f testing/testing_pod.yaml
pod/testing-s3-mount created    

bash$ kubectl exec -it pod/testing-s3-mount sh
/ # cd /var/s3
/var/s3 # touch a
```
