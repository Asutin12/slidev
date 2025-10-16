// EKS Auto Mode関連のコードサンプル

// AWS CLI - Auto Modeクラスター作成
const createAutoModeCluster = `
aws eks create-cluster \\
  --name automode-cluster \\
  --version 1.29 \\
  --role-arn arn:aws:iam::ACCOUNT:role/eks-service-role \\
  --compute-config nodePool=auto \\
  --vpc-config subnetIds=subnet-xxx,subnet-yyy
`;

// kubectl設定
const configureKubectl = `
# kubeconfig更新
aws eks update-kubeconfig --name automode-cluster

# 接続確認
kubectl get nodes
`;

// Nginx Deploymentサンプル
const nginxDeployment = `
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-automode
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
`;

// VPAサンプル
const vpaExample = `
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: nginx-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-automode
  updatePolicy:
    updateMode: "Auto"
`;

export { createAutoModeCluster, configureKubectl, nginxDeployment, vpaExample };
