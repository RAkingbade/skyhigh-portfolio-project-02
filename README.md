# SkyHigh Portfolio Project 2 — Production Network with Terraform

A complete AWS network built entirely with Terraform: a VPC with public and
private subnets across two availability zones, an Internet Gateway, a NAT
Gateway, security groups for a web and database tier, an EC2 web server, and
an S3 bucket for static assets. The VPC itself is built as a reusable
Terraform module.

## Architecture

- VPC (10.0.0.0/16)
- 2 public subnets (10.0.1.0/24, 10.0.2.0/24) across 2 AZs
- 2 private subnets (10.0.3.0/24, 10.0.4.0/24) across 2 AZs
- Internet Gateway for public subnet access
- NAT Gateway for private subnet egress
- Web security group (HTTP open, SSH restricted to my IP)
- Database security group (Postgres restricted to the web tier only)
- EC2 web server running nginx, deployed via user_data
- S3 bucket for static assets, private, versioned

## Tech Stack

Terraform · AWS VPC · EC2 · S3 · nginx · Terraform Modules

## Why I Built the VPC as a Module

Packaging the networking layer as a reusable module (`modules/vpc/`) means
this exact stack, VPC, subnets, gateways, routing, could be reused for a
completely different project just by changing the input values, without
rewriting any of the underlying logic. This mirrors how production teams
actually organize infrastructure code.

## How to Run This

```bash
terraform init
terraform plan
terraform apply
```

When done:

```bash
terraform destroy
```

## Cost Note

Everything here is Free Tier eligible except the NAT Gateway, which bills
hourly (~$0.045/hr). Total cost for building, testing, and tearing this down
was well under $1.

## Challenges & Solutions

1. **Wrong Free Tier instance type** — `t2.micro` isn't Free Tier eligible on
   newer AWS accounts; switched to `t3.micro`.
2. **No SSH access to debug the web server** — the original EC2 resource had
   no `key_name` set. Created a key pair, added it as a variable, and
   redeployed.
3. **Site loading via curl but not in-browser** — turned out to be the
   browser (Brave) auto-upgrading to HTTPS. Confirmed the server worked
   correctly with `curl -v` before chasing the wrong lead.

## What I'd Do Differently in Production

- Use remote state (S3 + DynamoDB) instead of local state, so a team could
  safely collaborate
- Add CI/CD to run `terraform plan` automatically on every pull request
- Split security groups into their own reusable module
