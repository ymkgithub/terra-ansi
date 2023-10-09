resource "aws_eks_cluster" "react-node-eks-cluster" {
    name        = "eks cluster"
    role_arn    = aws_iam_role.ymk_eks_cluster_role.arn
    
    vpc_config  {
        subnet_ids = data.terraform_remote_state.eks_vpc.outputs.subnet_ids
    }
}

resource "aws_iam_role" "ymk_eks_cluster_role" {
    name = "ymk_eks-cluster-role"

    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "react-node-AmazonEKSClusterPolicy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role        = aws_iam_role.ymk_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "react-node-AmazonEKSServicePolicy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role        = aws_iam_role.ymk_eks_cluster_role.name
}