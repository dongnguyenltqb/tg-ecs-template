### Add IAM User to manage cluster

---

1. Refer documentation https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
2. Create IAM user
3. Update `aws-auth` config map in `kube-system` namespace

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::XXXXX:role/cafeEKSNodeRole
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::XXXXX:user/cafeAdmin
      username: admin
      groups:
      - system:masters
```
