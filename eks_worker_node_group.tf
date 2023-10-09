resource "aws_eks_node_group" "aws_eks_node_group" {
    cluster_name    = "eks cluster"
    node_group_name = "eks worker node group"
    node_role_arn   = aws_iam_role.ymk_eks_worker_node_group_role.arn
    subnet_ids      = data.terraform_remote_state.eks_vpc.outputs.subnet_ids

    scaling_config {
        desired_size    = 3
        max_size        = 5
        min_size        = 2
    }
}

resource "aws_iam_role" "ymk_eks_worker_node_group_role" {
    name = "ymk_eks_worker_node_group_role"

    assume_role_policy = jsonencode({
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "react-node-AmazonEKSWorkerNodePolicy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role        = aws_iam_role.ymk_eks_worker_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "react-node-AmazonEKS_CNI_Policy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role        = aws_iam_role.ymk_eks_worker_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "react-node-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role        = aws_iam_role.ymk_eks_worker_node_group_role.name
}