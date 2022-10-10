AWSTemplateFormatVersion: "2010-09-09"
Description: 4 VPC + 3 Ubuntu Hosts
Metadata:
  'AWS::CloudFormation::Interface':
    ParameterGroups:
      - Label:
          default: Spoke1 VPC Configuration for S-N and E-W traffic
        Parameters:
          - SVPC1CIDR
          - SVPC1SubnetCIDRs
          - MyIPForAccess
      - Label:
          default: Spoke2 VPC Configuration for S-N and E-W traffic
        Parameters:
          - SVPC2CIDR
          - SVPC2SubnetCIDRs
      - Label:
          default: Spoke3 VPC Configuration for N-S traffic
        Parameters:
          - SVPCNSCIDR
          - SVPCNSSubnetCIDRs
      - Label:
          default: Security Hub Configuration
        Parameters:
          - VPCCIDR
          - RelaySubnet1
          - EndpointSubnet1
          - PublicSubnet1
          - PublicSubnet1RouterIP
          - GeneveSubnet1
          - GeneveSubnet1RouterIP
          - RelaySubnet2
          - EndpointSubnet2
          - PublicSubnet2
          - PublicSubnet2RouterIP
          - GeneveSubnet2
          - GeneveSubnet2RouterIP
          - InitS3Bucket
          - InitS3BucketRegion
          - MyGwlbName
      - Label:
          default: Host Configuration
        Parameters:
          - KEYNAME
          - InstanceType
          - MgmtHostPrivateIP
          - SpokeHostPrivateIP
      - Label:
          default: TGW Configuration
      - Label:
          default: FortiGate Instance Configuration
        Parameters:
          - AZForFGTA
          - AZForFGTB
          - FGTInstanceType
          - CIDRForFGTAccess
          - KeyPair
Parameters:
  MyIPForAccess:
    Type: String
    Default: "1.2.3.4/32"
    Description: Provide your IP address used to connect to the management device in spoke VPC 
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
  MyGwlbName:
      Type: String
      Default: "GWLBNAME"
  SVPC1CIDR:
    Type: String
    Default: 10.97.0.0/16
    Description: Provide a network CIDR for Spoke VPC1 - MGMT
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
  SVPC1SubnetCIDRs:
    Description: Comma-delimited list of CIDR blocks for VPC1 Format (AZ1 Subnet, AZ2 Subnet) Subnet)
    Type: CommaDelimitedList
    Default: '10.97.1.0/24, 10.97.2.0/24'
  SVPC2CIDR:
    Type: String
    Default: 10.98.0.0/16
    Description: Provide a network CIDR for Spoke VC2
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
  SVPC2SubnetCIDRs:
    Description: Comma-delimited list of CIDR blocks for VPC2 Format (AZ1 Subnet, AZ2 Subnet)
    Type: CommaDelimitedList
    Default: '10.98.1.0/24, 10.98.2.0/24'
  SVPCNSCIDR:
    Type: String
    Default: 10.95.0.0/16
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    Description: Enter the VPC CIDR that you are using for
  SVPCNSSubnetCIDRs:
    Description: Comma-delimited list of CIDR blocks for VPC3 Format (AZ1 Subnet, AZ2 Subnet)
    Type: CommaDelimitedList
    Default: '10.95.1.0/24, 10.95.2.0/24'
  KEYNAME:
    Description: Select Keypair for all hosts - Existing Keypair is required 
    Type: AWS::EC2::KeyPair::KeyName
  InstanceType:
    Description: EC2 Instance Type - Recommended small instance sizes
    Type: String
    Default: t3.micro
    AllowedValues:
    - t3.micro
    - t3.nano
    - t3.small
  MgmtHostPrivateIP:
    Description: Please provide and IP for the management Host (AZ1 in VPC1)
    Type: String
    Default: 10.97.1.10
  SpokeHostPrivateIP:
    Description: Please provide and IP for the testing Host in Spoke VPC2 (AZ1 in VPC1)
    Type: String
    Default: 10.98.1.10  
  VPCCIDR:
    Type: String
    Default: 10.0.0.0/16
    Description: Enter the VPC CIDR that you are using for security Hub
  AZForFGTA:
    Type: 'AWS::EC2::AvailabilityZone::Name'
    Description: Select the first AZ for FortiGateA
  AZForFGTB:
    Type: 'AWS::EC2::AvailabilityZone::Name'
    Description: Select the second AZ for FortiGateB
  RelaySubnet1:
    Type: String
    Default: 10.0.1.0/24
    Description: Provide a network CIDR for the Relay subnet1
  EndpointSubnet1:
    Type: String
    Default: 10.0.2.0/24
    Description: Provide a network CIDR for the endpoint subnet1
  GeneveSubnet1:
    Type: String
    Default: 10.0.3.0/24
    Description: Provide a network CIDR for the Geneve tunnels
  GeneveSubnet1RouterIP:
    Type: String
    Default: 10.0.3.1
    Description: Provide the IP of the gateway for the Geneve tunnels subnet1
  PublicSubnet1:
    Type: String
    Default: 10.0.4.0/24
    Description: Provide a network CIDR for the pubic subnet1
  PublicSubnet1RouterIP:
    Type: String
    Default: 10.0.4.1
    Description: Provide the IP of the gateway for the public subnet1
  RelaySubnet2:
    Type: String
    Default: 10.0.10.0/24
    Description: Provide a network CIDR for the Relay subnet2
  EndpointSubnet2:
    Type: String
    Default: 10.0.20.0/24
    Description: Provide a network CIDR for the endpoint subnet2
  GeneveSubnet2:
    Type: String
    Default: 10.0.30.0/24
    Description: Provide a network CIDR for the Geneve tunnels
  GeneveSubnet2RouterIP:
    Type: String
    Default: 10.0.30.1
    Description: Provide the IP of the gateway for the Geneve tunnels subnet2
  PublicSubnet2:
    Type: String
    Default: 10.0.40.0/24
    Description: Provide a network CIDR for the pubic subnet2
  PublicSubnet2RouterIP:
    Type: String
    Default: 10.0.40.1
    Description: Provide the IP of the gateway for the public subnet1
  FGTInstanceType:
    Type: String
    Default: c5.xlarge
    Description: Select the instance type for the FortiGates
    AllowedValues:
      - t3.xlarge
      - c5.xlarge
      - c5.2xlarge
      - c5.4xlarge
      - c5.9xlarge
      - c5.18xlarge
  CIDRForFGTAccess:
    Type: String
    Default: 0.0.0.0/0
    Description: Enter the CIDR from which FortiGate instances need to be accessed from
  KeyPair:
    Type: 'AWS::EC2::KeyPair::KeyName'
    Description: Select the keypair for the FortiGates
  InitS3Bucket:
    Type: 'String'
    Description: Provide the name of the S3 bucket to store the configuration of the FGT devices
  InitS3BucketRegion:
    Type: 'String'
    Description: Provide the name of region where the bucket is located
    AllowedValues:
      - af-south-1
      - me-south-1  
      - ap-east-1
      - ap-northeast-1
      - ap-northeast-2
      - ap-south-1
      - ap-southeast-1
      - ap-southeast-2
      - ca-central-1
      - eu-central-1
      - eu-north-1
      - eu-west-1
      - eu-west-2
      - eu-west-3
      - sa-east-1
      - us-east-1
      - us-east-2
      - us-west-1
      - us-west-2
Mappings:
  RegionMap:
    af-south-1:
       fgtami: ami-0b435d1cf16aa90e7
    eu-north-1:
       fgtami: ami-092c7f33e96a66602
    ap-south-1:
       fgtami: ami-024311ffde39d2c03
    eu-west-3:
       fgtami: ami-054bd339074d2f4f2
    eu-west-2:
       fgtami: ami-010a33c56a41769be
    eu-south-1:
       fgtami: ami-0f99c3f1f118ec33b
    eu-west-1:
       fgtami: ami-08128bac5135f4515
    ap-northeast-3:
       fgtami: ami-024cf678856ba0c03
    ap-northeast-2:
       fgtami: ami-0b9054cc488c2d27f
    me-south-1:
       fgtami: ami-0234ecd760256557f
    ap-northeast-1:
       fgtami: ami-08479d0bce02ca48b
    sa-east-1:
       fgtami: ami-0f812ef9070aba55b
    ca-central-1:
       fgtami: ami-0036e95e21ec5a86b
    ap-east-1:
       fgtami: ami-06c01d5bc4b43dc06
    ap-southeast-1:
       fgtami: ami-0e88fb5c5083105d0
    ap-southeast-2:
       fgtami: ami-0e61c467e7f353497
    ap-southeast-3:
       fgtami: ami-033647feb863a9186
    eu-central-1:
       fgtami: ami-09694024ef925305f
    us-east-1:
       fgtami: ami-0cd6ef98ec787702b
    us-east-2:
       fgtami: ami-0311d5e799e37bc0a
    us-west-1:
       fgtami: ami-0b107a3fa2ea40b90
    us-west-2:
       fgtami: ami-0a70f5380706e13ac
  AWSInstanceType2Arch:
    t3.micro:
      Arch: HVM64
    t3.nano:
      Arch: HVM64
    t3.small:
      Arch: HVM64
  AWSRegionArch2AMI:
    af-south-1:
      HVM64: ami-0438616cef15ba2ca
    eu-north-1:
      HVM64: ami-0eb6f319b31f7092d
    ap-south-1:
      HVM64: ami-08e0ca9924195beba
    eu-west-3:
      HVM64: ami-0ea4a063871686f37
    eu-west-2:
      HVM64: ami-098828924dc89ea4a
    eu-west-1:
      HVM64: ami-0fc970315c2d38f01
    ap-northeast-2:
      HVM64: ami-09282971cf2faa4c9
    me-south-1:
      HVM64: ami-0cc4f2b06b56d27e9
    ap-northeast-1:
      HVM64: ami-0992fc94ca0f1415a 
    sa-east-1:
      HVM64: ami-089aac6323aa08aee
    ca-central-1:
      HVM64: ami-075cfad2d9805c5f2
    ap-east-1:
      HVM64: ami-040f64b9a031d8eb0
    ap-southeast-1:
      HVM64: ami-0e2e44c03b85f58b3
    ap-southeast-2: 
      HVM64: ami-04f77aa5970939148
    eu-central-1:
      HVM64: ami-0a6dc7529cd559185
    us-east-1:
      HVM64: ami-047a51fa27710816e
    us-east-2:
      HVM64: ami-01aab85a5e4a5a0fe
    us-west-1:
      HVM64: ami-005c06c6de69aee84
    us-west-2:
      HVM64: ami-0e999cbd62129e3b1
Conditions: {}
Resources:
  SPK1MGMTVPC:
    Type: 'AWS::EC2::VPC'
    Properties:
      CidrBlock: !Ref SVPC1CIDR
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Join 
              - '-'
              - - !Ref 'AWS::StackName'
                - SPK1VPC-Client-EW-SN
  SPK1VPCSUB1:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref SPK1MGMTVPC
      CidrBlock: !Select 
        - 0
        - !Ref SVPC1SubnetCIDRs
      AvailabilityZone: !Select 
        - 0
        - Fn::GetAZs: !Ref 'AWS::Region'
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK1PublicSUB
  SPK2VPC:
    Type: 'AWS::EC2::VPC'
    Properties:
      CidrBlock: !Ref SVPC2CIDR
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK2VPC-Server-EW-SN
  SPK2VPCSUB1:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref SPK2VPC
      CidrBlock: !Select 
        - 0
        - !Ref SVPC2SubnetCIDRs
      AvailabilityZone: !Select 
        - 1
        - Fn::GetAZs: !Ref 'AWS::Region'
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK2PublicSUB
  SPKNSVPC:
    Type: 'AWS::EC2::VPC'
    Properties:
      CidrBlock: !Ref SVPCNSCIDR
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Join 
              - '-'
              - - !Ref 'AWS::StackName'
                - SPKVPC-Server-NorthSouth
  SPKNSVPCSUB1:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref SPKNSVPC
      CidrBlock: !Select 
        - 0
        - !Ref SVPCNSSubnetCIDRs
      AvailabilityZone: !Select 
        - 1
        - Fn::GetAZs: !Ref 'AWS::Region'
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPKNSPublicSUB
  SPKNSVPCEndpointSub:
    Type: 'AWS::EC2::Subnet'
    Properties:
      VpcId: !Ref SPKNSVPC
      CidrBlock: !Select 
        - 1
        - !Ref SVPCNSSubnetCIDRs
      AvailabilityZone: !Select 
        - 1
        - Fn::GetAZs: !Ref 'AWS::Region'
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPKNSEndpointSUB
  VPCID:
    Properties:
      CidrBlock: !Ref VPCCIDR
      Tags:
        - Key: Name
          Value: 
            !Join 
              - '-'
              - - !Ref 'AWS::StackName'
                - SECHUBVPC
    Type: 'AWS::EC2::VPC'
  RelaySubnetA:
    Properties:
      AvailabilityZone: !Ref AZForFGTA
      CidrBlock: !Ref RelaySubnet1
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - RelaySubnetA
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  EndpointSubnetA:
    Properties:
      AvailabilityZone: !Ref AZForFGTA
      CidrBlock: !Ref EndpointSubnet1
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - EndpointSubnetA
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  PublicSubnetA:
    Properties:
      AvailabilityZone: !Ref AZForFGTA
      CidrBlock: !Ref PublicSubnet1
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - PublicSubnetA
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  GeneveSubnetA:
    Properties:
      AvailabilityZone: !Ref AZForFGTA
      CidrBlock: !Ref GeneveSubnet1
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - GNVSubnetA
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  RelaySubnetB:
    Properties:
      AvailabilityZone: !Ref AZForFGTB
      CidrBlock: !Ref RelaySubnet2
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - RelaySubnetB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  EndpointSubnetB:
    Properties:
      AvailabilityZone: !Ref AZForFGTB
      CidrBlock: !Ref EndpointSubnet2
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - EndpointSubnetB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  PublicSubnetB:
    Properties:
      AvailabilityZone: !Ref AZForFGTB
      CidrBlock: !Ref PublicSubnet2
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - PublicSubnetB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  GeneveSubnetB:
    Properties:
      AvailabilityZone: !Ref AZForFGTB
      CidrBlock: !Ref GeneveSubnet2
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - GNVSubnetB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::Subnet'
  AttachGateway:
    Properties:
      InternetGatewayId: !Ref IGWSECHUB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::VPCGatewayAttachment'
  IGWSECHUB:
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - IGW-SECHUB
    Type: 'AWS::EC2::InternetGateway'
  AttachGateway2:
    Properties:
      InternetGatewayId: !Ref IGWSPK
      VpcId: !Ref SPK1MGMTVPC
    Type: 'AWS::EC2::VPCGatewayAttachment'
  AttachGateway3:
    Properties:
      InternetGatewayId: !Ref IGWSPK2
      VpcId: !Ref SPK2VPC
    Type: 'AWS::EC2::VPCGatewayAttachment'
  AttachGateway4:
    Properties:
      InternetGatewayId: !Ref IGWSPK3
      VpcId: !Ref SPKNSVPC
    Type: 'AWS::EC2::VPCGatewayAttachment'
  IGWSPK:
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - IGW-SPOKE
    Type: 'AWS::EC2::InternetGateway'
  IGWSPK2:
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - IGW-SPOKE2
    Type: 'AWS::EC2::InternetGateway'
  IGWSPK3:
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - IGW-SPOKE3
    Type: 'AWS::EC2::InternetGateway'
  PublicRouteTableHUB:
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - PUB-RT-SECHUB
      VpcId: !Ref VPCID
    Type: 'AWS::EC2::RouteTable'
  EndPointRouteTableHUB:
    Type: 'AWS::EC2::RouteTable'
    DependsOn: TgwRouteTableSecHub
    Properties:
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - EndPpoint-RT-SECHUB
      VpcId: !Ref VPCID
  EndPointRouteHUBtoTGW:
    Type: 'AWS::EC2::Route'
    DependsOn: 
    - TGW1
    - EndPointRouteTableHUB
    Properties:
      DestinationCidrBlock: 0.0.0.0/0
      TransitGatewayId: !Ref TGW1
      RouteTableId: !Ref EndPointRouteTableHUB
  PublicDefaultRouteHUB:
    DependsOn: AttachGateway
    Type: 'AWS::EC2::Route'
    Properties:
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref IGWSECHUB
      RouteTableId: !Ref PublicRouteTableHUB
  SubnetRouteTableAssociationHUBEndPointATGW:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref EndpointSubnetA
      RouteTableId: !Ref EndPointRouteTableHUB
  SubnetRouteTableAssociationHUBEndPointBTGW:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref EndpointSubnetB
      RouteTableId: !Ref EndPointRouteTableHUB
  SubnetRouteTableAssociationHUBRelayA:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref RelaySubnetA
      RouteTableId: !Ref RelayRouteTableA
  SubnetRouteTableAssociationHUBRelayB:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref RelaySubnetB
      RouteTableId: !Ref RelayRouteTableB
  SubnetRouteTableAssociationHUBPUBA:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref PublicSubnetA
      RouteTableId: !Ref PublicRouteTableHUB
  SubnetRouteTableAssociationHUBPUBB:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref PublicSubnetB
      RouteTableId: !Ref PublicRouteTableHUB
  RouteTableSPK1PUB:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref SPK1MGMTVPC
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK1VPC-RT
  PublicDefaultRouteSPK1:
    DependsOn: AttachGateway
    Properties:
      DestinationCidrBlock: !Ref MyIPForAccess
      GatewayId: !Ref IGWSPK
      RouteTableId: !Ref RouteTableSPK1PUB
    Type: 'AWS::EC2::Route'
  SubnetRouteTableAssociationSPK1PUB:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref SPK1VPCSUB1
      RouteTableId: !Ref RouteTableSPK1PUB
  RouteTableSPK2PUB:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref SPK2VPC
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK2VPC-RT
  PublicDefaultRouteSPK2:
    DependsOn: AttachGateway
    Type: 'AWS::EC2::Route'
    Properties:
      DestinationCidrBlock: !Ref MyIPForAccess
      GatewayId: !Ref IGWSPK2
      RouteTableId: !Ref RouteTableSPK2PUB
  SubnetRouteTableAssociationSPK2:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref SPK2VPCSUB1
      RouteTableId: !Ref RouteTableSPK2PUB
  SubnetGWRouteTableAssociationSPK3IGW:
    Type: 'AWS::EC2::GatewayRouteTableAssociation'
    Properties:
      GatewayId: !Ref IGWSPK3
      RouteTableId: !Ref RouteTableSPK3IGW
  SubnetPublicRouteTableAssociationSPK3IGW:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref SPKNSVPCSUB1
      RouteTableId: !Ref RouteTableSPK3PUB
  SubnetEndpointRouteTableAssociationSPK3IGW:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref SPKNSVPCEndpointSub
      RouteTableId: !Ref RouteTableSPK3Endpoint
  RouteTableSPK3PUB:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref SPKNSVPC
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK3VPC-RT
  PublicDefaultRouteSPK3:
    DependsOn: AttachGateway4
    Type: 'AWS::EC2::Route'
    Properties:
      DestinationCidrBlock: 0.0.0.0/0
      VpcEndpointId: !Ref VPCEndpointC
      RouteTableId: !Ref RouteTableSPK3PUB
  RouteTableSPK3IGW:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref SPKNSVPC
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK3IGW-RT
  PublicDefaultRouteSPK3IGW:
    DependsOn: AttachGateway4
    Type: 'AWS::EC2::Route'
    Properties:
      DestinationCidrBlock: !Select 
        - 0
        - !Ref SVPCNSSubnetCIDRs
      VpcEndpointId: !Ref VPCEndpointC
      RouteTableId: !Ref RouteTableSPK3IGW
  RouteTableSPK3Endpoint:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref SPKNSVPC
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK3VPCEndpoint-RT
  PublicDefaultRouteSPK3Endpoint:
    DependsOn: AttachGateway4
    Type: 'AWS::EC2::Route'
    Properties:
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref IGWSPK3
      RouteTableId: !Ref RouteTableSPK3Endpoint
  EIPMGMTHOSTENI1:
    Type: AWS::EC2::EIP
    DependsOn: AttachGateway2
    Properties: 
      Domain: vpc
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK1-MGMT-HOST-ENIEIP
  MGMTHOSTENI:
    Type: AWS::EC2::NetworkInterface
    Properties:
      Description: ENI for MGMT-HOST
      SourceDestCheck: false
      GroupSet:
      - !Ref InstanceSecurityGroupSPK1
      SubnetId: !Ref SPK1VPCSUB1
      PrivateIpAddress: !Ref MgmtHostPrivateIP
      Tags:
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK-MGMT-HOST-ENI1
  EIPNSSRVENI1:
    Type: AWS::EC2::EIP
    DependsOn: AttachGateway4
    Properties: 
      Domain: vpc
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK3-SERVER-ENIEIP
  EIPAssociationMGMT:
    Type: AWS::EC2::EIPAssociation
    Properties:
      EIP: !Ref EIPMGMTHOSTENI1
      InstanceId: !Ref MGMTHOST
  IPAssociationSPK3SRV:
    Type: AWS::EC2::EIPAssociation
    Properties:
      EIP: !Ref EIPNSSRVENI1
      InstanceId: !Ref SRVHOST
  MGMTHOST:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref KEYNAME
      ImageId: !FindInMap [ AWSRegionArch2AMI, !Ref 'AWS::Region' , !FindInMap [ AWSInstanceType2Arch, !Ref InstanceType, Arch ] ]
      InstanceType: !Ref InstanceType
      NetworkInterfaces:
      - NetworkInterfaceId: 
          Ref: MGMTHOSTENI
        DeviceIndex: '0'
      UserData: !Base64 |
        #!/bin/bash -ex
        # put your script here
      Tags:
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK1-MGMT-HOST
  TESTHOST:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref KEYNAME
      ImageId: !FindInMap [ AWSRegionArch2AMI, !Ref 'AWS::Region' , !FindInMap [ AWSInstanceType2Arch, !Ref InstanceType, Arch ] ]
      InstanceType: !Ref InstanceType
      NetworkInterfaces:
        - DeviceIndex: '0'
          GroupSet: 
          - !Ref InstanceSecurityGroupSPK2
          SubnetId: !Ref SPK2VPCSUB1
          PrivateIpAddress: !Ref SpokeHostPrivateIP     
      UserData: !Base64 |
        #!/bin/bash -ex
        # put your script here
      Tags:
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK2-TEST-HOST
  SRVHOST:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref KEYNAME
      ImageId: !FindInMap [ AWSRegionArch2AMI, !Ref 'AWS::Region' , !FindInMap [ AWSInstanceType2Arch, !Ref InstanceType, Arch ] ]
      InstanceType: !Ref InstanceType
      NetworkInterfaces:
        - DeviceIndex: '0'
          GroupSet: 
          - !Ref InstanceSecurityGroupSPK3
          SubnetId: !Ref SPKNSVPCSUB1 
      UserData: !Base64 |
        #!/bin/bash -ex
        # put your script here
      Tags:
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SPK3-SRV-HOST
  InstanceSecurityGroupHUB:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref VPCID
      GroupDescription: allows all traffic
      SecurityGroupIngress:
      - IpProtocol: '-1'
        FromPort: 0
        ToPort: 65535
        CidrIp: 0.0.0.0/0
  InstanceSecurityGroupSPK1:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref SPK1MGMTVPC
      GroupDescription: allows all traffic
      SecurityGroupIngress:
      - IpProtocol: '-1'
        FromPort: 0
        ToPort: 65535
        CidrIp: 0.0.0.0/0
  InstanceSecurityGroupSPK2:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref SPK2VPC
      GroupDescription: allows all traffic
      SecurityGroupIngress:
      - IpProtocol: '-1'
        FromPort: 0
        ToPort: 65535
        CidrIp: 0.0.0.0/0
  InstanceSecurityGroupSPK3:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref SPKNSVPC
      GroupDescription: allows all traffic
      SecurityGroupIngress:
      - IpProtocol: '-1'
        FromPort: 0
        ToPort: 65535
        CidrIp: 0.0.0.0/0
  TGW1:
    Type: AWS::EC2::TransitGateway
    Properties: 
      AutoAcceptSharedAttachments: enable
      DefaultRouteTableAssociation: disable
      DefaultRouteTablePropagation: disable
      Description: Main Transit Gateway for Security Hub      
      DnsSupport: enable
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - TGW1
      VpnEcmpSupport: enable
  TgwAttSPK1:
    Type: AWS::EC2::TransitGatewayAttachment
    DependsOn: TGW1
    Properties: 
      SubnetIds: 
      - !Ref SPK1VPCSUB1
      TransitGatewayId: !Ref TGW1
      VpcId: !Ref SPK1MGMTVPC
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - ATT-SPK1
  TgwAttSPK2:
    Type: AWS::EC2::TransitGatewayAttachment
    DependsOn: TGW1
    Properties: 
      SubnetIds: 
      - !Ref SPK2VPCSUB1
      TransitGatewayId: !Ref TGW1
      VpcId: !Ref SPK2VPC
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - ATT-SPK2
  TgwAttHUB:
    Type: AWS::EC2::TransitGatewayAttachment
    DependsOn: TGW1
    Properties: 
      SubnetIds: 
      - !Ref RelaySubnetA
      - !Ref RelaySubnetB
      TransitGatewayId: !Ref TGW1
      VpcId: !Ref VPCID
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - ATT-HUB
  TgwRouteTableVPC:
    Type: AWS::EC2::TransitGatewayRouteTable
    Properties: 
      TransitGatewayId: !Ref TGW1
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - VPC
  TgwRouteTableSecHub:
    Type: AWS::EC2::TransitGatewayRouteTable
    Properties: 
      TransitGatewayId: !Ref TGW1
      Tags: 
        - Key: Name
          Value: !Join
            - '-'
            - - !Ref 'AWS::StackName'
              - SECHUB
  TgwAssocSPK1toVPC:
    Type: AWS::EC2::TransitGatewayRouteTableAssociation
    Properties: 
      TransitGatewayAttachmentId: !Ref TgwAttSPK1
      TransitGatewayRouteTableId: !Ref TgwRouteTableVPC
  TgwAssocSPK2toVPC:
    Type: AWS::EC2::TransitGatewayRouteTableAssociation
    Properties: 
      TransitGatewayAttachmentId: !Ref TgwAttSPK2
      TransitGatewayRouteTableId: !Ref TgwRouteTableVPC
  TgwAssocHUBtoTGW:
    Type: AWS::EC2::TransitGatewayRouteTableAssociation
    Properties: 
      TransitGatewayAttachmentId: !Ref TgwAttHUB
      TransitGatewayRouteTableId: !Ref TgwRouteTableSecHub
  TgwPropagateSPK1toHUB:
    Type: AWS::EC2::TransitGatewayRouteTablePropagation
    Properties: 
      TransitGatewayAttachmentId: !Ref TgwAttSPK1
      TransitGatewayRouteTableId: !Ref TgwRouteTableSecHub
  TgwPropagateSPK2toHUB:
    Type: AWS::EC2::TransitGatewayRouteTablePropagation
    Properties: 
      TransitGatewayAttachmentId: !Ref TgwAttSPK2
      TransitGatewayRouteTableId: !Ref TgwRouteTableSecHub
  TgwRouteVPC:
    Type: 'AWS::EC2::TransitGatewayRoute'
    DependsOn: TGW1
    Properties:
      DestinationCidrBlock: 0.0.0.0/0
      TransitGatewayAttachmentId: !Ref TgwAttHUB
      TransitGatewayRouteTableId: !Ref TgwRouteTableVPC
  VPCRouteSPK1:
    Type: 'AWS::EC2::Route'
    DependsOn: TgwAttSPK1
    Properties:
      RouteTableId: !Ref RouteTableSPK1PUB
      DestinationCidrBlock: 0.0.0.0/0
      TransitGatewayId: !Ref TGW1
  VPCRouteSPK2:
    Type: 'AWS::EC2::Route'
    DependsOn: TgwAttSPK2
    Properties:
      RouteTableId: !Ref RouteTableSPK2PUB
      DestinationCidrBlock: 0.0.0.0/0
      TransitGatewayId: !Ref TGW1
  FGTSecGrpBase:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      VpcId: !Ref VPCID
      GroupDescription: FGTSecGrp
      SecurityGroupIngress:
        - Description: Allow remote access to FGT
          IpProtocol: '-1'
          FromPort: 0
          ToPort: 65535
          CidrIp: !Ref CIDRForFGTAccess
        - Description: Allow local VPC access to FGT
          IpProtocol: '-1'
          FromPort: 0
          ToPort: 65535
          CidrIp: !Ref VPCCIDR
  GWLBSecGrpBase:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      VpcId: !Ref VPCID
      GroupDescription: GWLBSecGrp
      SecurityGroupIngress:
        - Description: Allow remote access 
          IpProtocol: '-1'
          FromPort: 0
          ToPort: 65535
          CidrIp: 0.0.0.0/0
        - Description: Allow local VPC 
          IpProtocol: '-1'
          FromPort: 0
          ToPort: 65535
          CidrIp: 0.0.0.0/0
  FGTSecGrpFGTRule:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      GroupId: !Ref FGTSecGrpBase
      Description: Allow FGTs to access each other
      IpProtocol: '-1'
      FromPort: 0
      ToPort: 65535
      SourceSecurityGroupId: !Ref FGTSecGrpBase
  InstanceRole:
    Type: AWS::IAM::Role
    Properties: 
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement: 
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: 
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: GetPolicy
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 's3:GetObject'
                Resource: '*'
  InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: /
      Roles: 
        - !Ref InstanceRole
  FgtA:
    Type: 'AWS::EC2::Instance'
    DependsOn: RunInitFunction
    Properties:
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - fgtami
      InstanceType: !Ref FGTInstanceType
      IamInstanceProfile: !Ref InstanceProfile
      KeyName: !Ref KeyPair
      NetworkInterfaces:
        - NetworkInterfaceId: !Ref FGTAENI0
          DeviceIndex: '0'
        - NetworkInterfaceId: !Ref FGTAENI1
          DeviceIndex: '1'
        - NetworkInterfaceId: !Ref FGTAENI2
          DeviceIndex: '2'
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - '-FgtA'
      UserData: 
        Fn::Base64: !Join
          - ""
          - - "{\n" 
            - "\"bucket\""
            - " : \""
            - !Ref InitS3Bucket
            - "\""
            - ",\n"
            - "\"region\""
            - " : "
            - "\""
            - !Ref InitS3BucketRegion
            - "\""
            - ",\n"
            - "\"license\""
            - " : " 
            - "\""
            - "/"
            - "no"
            - "\""
            - ",\n"
            - "\"config\""
            - " : "
            - "\""
            - "/fgtA.txt\""
            - "\n"
            - "}"
  FgtB:
    Type: 'AWS::EC2::Instance'
    DependsOn: RunInitFunction
    Properties:
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - fgtami
      InstanceType: !Ref FGTInstanceType
      IamInstanceProfile: !Ref InstanceProfile
      KeyName: !Ref KeyPair
      NetworkInterfaces:
        - NetworkInterfaceId: !Ref FGTBENI0
          DeviceIndex: '0'
        - NetworkInterfaceId: !Ref FGTBENI1
          DeviceIndex: '1'
        - NetworkInterfaceId: !Ref FGTBENI2
          DeviceIndex: '2'
      Tags:
        - 
          Key: Name
          Value: !Join 
          - ''
          - - !Ref 'AWS::StackName'
            - '-FgtB'
      UserData:
        Fn::Base64: !Join
          - ""
          - - "{\n" 
            - "\"bucket\""
            - " : \""
            - !Ref InitS3Bucket
            - "\""
            - ",\n"
            - "\"region\""
            - " : "
            - "\""
            - !Ref InitS3BucketRegion
            - "\""
            - ",\n"
            - "\"license\""
            - " : " 
            - "\""
            - "/"
            - "no"
            - "\""
            - ",\n"
            - "\"config\""
            - " : "
            - "\""
            - "/fgtB.txt\""
            - "\n"
            - "}"
  FGTAENI0:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port1
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck: false
      SubnetId: !Ref PublicSubnetA
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - FgtAENI0
        - Key: Interface
          Value: eth0
  FGTBENI0:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port1
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck: false
      SubnetId: !Ref PublicSubnetB
      Tags:
        - Key: Name
          Value: !Join
            - ''
            - - !Ref 'AWS::StackName'
              - FgtBENI0
        - Key: Interface
          Value: eth0
  FGTAENI1:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port2
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck:  false
      SubnetId: !Ref GeneveSubnetA
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - FgtAENI1
  FGTBENI1:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port2
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck:  false
      SubnetId: !Ref GeneveSubnetB
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - FgtBENI1
  FGTAENI2:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port3
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck:  false
      SubnetId: !Ref PublicSubnetA
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - FgtAENI3
  FGTBENI2:
    Type: 'AWS::EC2::NetworkInterface'
    Properties:
      Description: port3
      GroupSet:
        - !Ref FGTSecGrpBase
      SourceDestCheck:  false
      SubnetId: !Ref PublicSubnetB
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - FgtBENI3
  FgtAMgmtEIP:
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
    DependsOn: FgtA
  FgtBMgmtEIP:
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
    DependsOn: FgtB
  FgtAInternetEIP:
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
    DependsOn: FgtA
  FgtBInternetEIP:
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
    DependsOn: FgtB
  FgtAMgmtEIPASSOCIATION:
    Type: 'AWS::EC2::EIPAssociation'
    Properties:
      AllocationId: !GetAtt 
        - FgtAMgmtEIP
        - AllocationId
      NetworkInterfaceId: !Ref FGTAENI0
  FgtBMgmtEIPASSOCIATION:
    Type: 'AWS::EC2::EIPAssociation'
    Properties:
      AllocationId: !GetAtt 
        - FgtBMgmtEIP
        - AllocationId
      NetworkInterfaceId: !Ref FGTBENI0
  FgtAInternetEIPASSOCIATION:
    Type: 'AWS::EC2::EIPAssociation'
    Properties:
      AllocationId: !GetAtt 
        - FgtAInternetEIP
        - AllocationId
      NetworkInterfaceId: !Ref FGTAENI2
  FgtBInternetEIPASSOCIATION:
    Type: 'AWS::EC2::EIPAssociation'
    Properties:
      AllocationId: !GetAtt 
        - FgtBInternetEIP
        - AllocationId
      NetworkInterfaceId: !Ref FGTBENI2
  RelayRouteTableA:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref VPCID
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - '-RelayRouteTableA'
  RelayRouteTableB:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref VPCID
      Tags:
        - Key: Name
          Value: !Join 
            - ''
            - - !Ref 'AWS::StackName'
              - '-RelayRouteTableB'
  RelayDefaultRouteA:
    Type: 'AWS::EC2::Route'
    Properties:
      RouteTableId: !Ref RelayRouteTableA
      DestinationCidrBlock: 0.0.0.0/0
      VpcEndpointId: !Ref VPCEndpointA
  RelayDefaultRouteB:
    Type: 'AWS::EC2::Route'
    Properties:
      RouteTableId: !Ref RelayRouteTableB
      DestinationCidrBlock: 0.0.0.0/0
      VpcEndpointId: !Ref VPCEndpointB
  GatewayLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties: 
      Name: !Ref 'MyGwlbName'
      Subnets: 
        - !Ref 'GeneveSubnetA'
        - !Ref 'GeneveSubnetB'
      LoadBalancerAttributes:
        - Key: load_balancing.cross_zone.enabled
          Value: 'true'
      Tags:
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - !Ref 'MyGwlbName'
      Type: gateway
  GWLBServiceEndpoint:
    Type: AWS::EC2::VPCEndpointService
    Properties: 
      AcceptanceRequired: false
      GatewayLoadBalancerArns: 
        - !Ref GatewayLoadBalancer
  VPCEndpointA:
    DependsOn: FgtAMgmtEIP
    Type: AWS::EC2::VPCEndpoint
    Properties: 
      ServiceName: !Join
        - ""
        - - !Sub 'com.amazonaws.vpce.${AWS::Region}.' 
          - !Ref GWLBServiceEndpoint
      SubnetIds: 
        - !Ref EndpointSubnetA
      VpcEndpointType: GatewayLoadBalancer
      VpcId: !Ref VPCID
  VPCEndpointB:
    DependsOn: FgtBMgmtEIP
    Type: AWS::EC2::VPCEndpoint
    Properties: 
      ServiceName: !Join
        - ""
        - - !Sub 'com.amazonaws.vpce.${AWS::Region}.' 
          - !Ref GWLBServiceEndpoint
      SubnetIds: 
        - !Ref EndpointSubnetB
      VpcEndpointType: GatewayLoadBalancer
      VpcId: !Ref VPCID
  VPCEndpointC:
    DependsOn: FgtAMgmtEIP
    Type: AWS::EC2::VPCEndpoint
    Properties: 
      ServiceName: !Join
        - ""
        - - !Sub 'com.amazonaws.vpce.${AWS::Region}.' 
          - !Ref GWLBServiceEndpoint
      SubnetIds: 
        - !Ref SPKNSVPCEndpointSub
      VpcEndpointType: GatewayLoadBalancer
      VpcId: !Ref SPKNSVPC
  GWLBListener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties: 
      DefaultActions: 
        - Type: "forward"
          TargetGroupArn: !Ref FGTTargetGroup
      LoadBalancerArn: !Ref GatewayLoadBalancer
  FGTTargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties: 
      HealthCheckEnabled: True
      HealthCheckIntervalSeconds: 5
      HealthCheckPath: /
      HealthCheckPort: '80'
      HealthCheckProtocol: 'HTTP'
      Port: 6081
      Protocol: GENEVE
      Tags: 
        - Key: Name
          Value: !Join 
            - '-'
            - - !Ref 'AWS::StackName'
              - 'TargetGroup'
      Targets: 
        - Id : !GetAtt FGTAENI1.PrimaryPrivateIpAddress
        - Id : !GetAtt FGTBENI1.PrimaryPrivateIpAddress
      TargetType: ip
      VpcId: !Ref VPCID
  LambdaRole:
    Type: AWS::IAM::Role
    DependsOn: GatewayLoadBalancer
    Properties: 
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement: 
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action:
            - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: LambdaAccessRole
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 's3:PutObject'
                  - 'ec2:*' 
                  - 'elasticloadbalancing:*'
                Resource: '*'
              - Effect: Allow
                Action:
                  - 'logs:*' 
                Resource: '*'
  InitFunction:
    Type: AWS::Lambda::Function
    DependsOn: GatewayLoadBalancer
    Properties:
      Code:
        ZipFile: !Join
          - "\n"
          - - import ast
            - import boto3
            - import cfnresponse
            - import json 
            - s3client = boto3.client('s3')
            - ec2client = boto3.client('ec2')
            - lbclient = boto3.client('elbv2')
            - ''
            - template = '''\
            - config system global
            - set hostname {hostname}
            - set vdom-mode multi-vdom
            - end
            - config vdom 
            - edit root 
            - config system settings
            - set vdom-type admin
            - end
            - end
            - config vdom 
            - edit fg-traffic
            - config system settings
            - set vdom-type traffic
            - end
            - end
            - config global
            - config system interface
            - edit port1
            - set vdom "root"
            - set defaultgw disable
            - set allowaccess ping http https ssh
            - next
            - edit port2
            - set vdom "fg-traffic"
            - set defaultgw disable
            - set allowaccess ping http https ssh
            - next
            - edit port3
            - set vdom "fg-traffic"
            - set defaultgw disable
            - set allowaccess ping http https ssh
            - end
            - end
            - end
            - config vdom
            - edit root
            - config router static
            - edit 1
            - set gateway {PublicSubnetRouterIP}
            - set device "port1"
            - end
            - end
            - config vdom
            - edit fg-traffic
            - config system geneve
            - edit "gen"
            - set interface "port2"
            - set type ppp
            - set remote-ip {GWLBIp}
            - next
            - end
            - config firewall address
            - edit CIDR1
            - set subnet {VPCSPK1}
            - next
            - edit CIDR2
            - set subnet {VPCSPK2}
            - next
            - edit CIDR3
            - set subnet {VPCSPK3}
            - next
            - end
            - config firewall addrgrp
            - edit local
            - set member "CIDR1" "CIDR2" "CIDR3"
            - end
            - config firewall policy
            - edit 1
            - set name "all"
            - set srcintf "gen"
            - set dstintf "gen"
            - set srcaddr "all"
            - set dstaddr "all"
            - set action accept
            - set schedule "always"
            - set service "ALL"
            - set logtraffic all
            - next
            - edit 2
            - set name "toInternet"
            - set srcintf "gen"
            - set dstintf "port3"
            - set srcaddr "all"
            - set dstaddr "all"
            - set action accept
            - set schedule "always"
            - set service "ALL"
            - set logtraffic all
            - set nat enable
            - next
            - end
            - config router policy
            - edit 2
            - set input-device "gen"
            - set srcaddr "all"
            - set dstaddr "local"
            - set output-device "gen"
            - next
            - edit 1
            - set input-device "gen"
            - set srcaddr "local"
            - set dst "0.0.0.0/0.0.0.0"
            - set gateway {PublicSubnetRouterIP}
            - set output-device "port3"
            - next
            - end
            - config router static
            - edit 1
            - set gateway {GWLBIp}
            - set device "gen"
            - next
            - edit 2
            - set gateway {PublicSubnetRouterIP}
            - set device "port3"
            - end
            - end
            - end\
            - "'''"
            - ''
            - "def handler(event, context):"
            - "    errors = False"
            - "    gendict = ast.literal_eval(event['ResourceProperties']['General'])" 
            - "    dict1 = ast.literal_eval(event['ResourceProperties']['FGTAInfo'])"    
            - "    dict2 = ast.literal_eval(event['ResourceProperties']['FGTBInfo'])"
            - "    response0 = ec2client.modify_transit_gateway_vpc_attachment("
            - "        TransitGatewayAttachmentId=gendict['AttachementId'],"
            - "        Options={"
            - "            'ApplianceModeSupport': 'enable'"
            - "        }"
            - "    )"
            - "    if response0['ResponseMetadata']['HTTPStatusCode'] != 200:"
            - "        errors = True"
            - "    response1 = lbclient.describe_load_balancers(Names=[gendict['gwlbname']])"
            - "    if response1['ResponseMetadata']['HTTPStatusCode'] == 200:"
            - "        arn = response1['LoadBalancers'][0]['LoadBalancerArn']"
            - "        GWLBDescription = 'ELB '+arn.split('/',1)[1]"
            - "    else:"
            - "        errors = True"
            - "    response2 = ec2client.describe_network_interfaces("
            - "        Filters=[{'Name': 'description','Values': [GWLBDescription]}])"
            - "    if response2['ResponseMetadata']['HTTPStatusCode'] == 200:"
            - "        if response2['NetworkInterfaces'][0]['AvailabilityZone'] == dict1['zone']:"
            - "            dict1.update({'GWLBIp':response2['NetworkInterfaces'][0]['PrivateIpAddress']})"
            - "            dict2.update({'GWLBIp':response2['NetworkInterfaces'][1]['PrivateIpAddress']})"
            - "        elif response2['NetworkInterfaces'][0]['AvailabilityZone'] == dict2['zone']:"
            - "            dict2.update({'GWLBIp':response2['NetworkInterfaces'][0]['PrivateIpAddress']})"
            - "            dict1.update({'GWLBIp':response2['NetworkInterfaces'][1]['PrivateIpAddress']})"
            - "        else:"
            - "            errors = True"
            - "    else:"
            - "        errors = True"
            - "    if errors == False:"
            - "        fgtA_conf = template.format(**dict1)"
            - "        fgtB_conf = template.format(**dict2)"
            - "    try:"
            - "      resp = s3client.put_object(Body=fgtA_conf, Bucket=event['ResourceProperties']['S3Bucket'], Key='fgtA.txt')"
            - "    except Exception as error:" 
            - "      responseData = {'msg':'error'}"
            - "      cfnresponse.send(event, context, cfnresponse.FAILED, responseData)"
            - "    if resp['ResponseMetadata']['HTTPStatusCode'] == 200:"
            - "        fgtA_result = True"
            - "        print('<-- s3 put_object fgtA.txt successful')"
            - "    try:"
            - "      resp = s3client.put_object(Body=fgtB_conf, Bucket=event['ResourceProperties']['S3Bucket'], Key='fgtB.txt')"
            - "    except Exception as error:"
            - "      responseData = {'msg':'error'}"
            - "      cfnresponse.send(event, context, cfnresponse.FAILED, responseData)"
            - "    if resp['ResponseMetadata']['HTTPStatusCode'] == 200:"
            - "        fgtB_result = True"
            - "        print('<-- s3 put_object fgtB.txt successful')"
            - "    if fgtA_result is True and fgtB_result is True and errors is False:"
            - "        responseData = {'msg':'200'}"
            - "        cfnresponse.send(event, context, cfnresponse.SUCCESS, responseData)"
            - "    else:"
            - "        responseData = {'msg':'error'}"
            - "        cfnresponse.send(event, context, cfnresponse.FAILED, responseData)"
      Role: !GetAtt
        - LambdaRole
        - Arn
      Timeout: 120  
      Handler: index.handler
      Runtime: python3.8
      MemorySize: 128
  RunInitFunction: 
    Type: Custom::InitFunction
    Properties:
      ServiceToken: !GetAtt 
        - InitFunction
        - Arn
      S3Bucket: !Ref InitS3Bucket
      General: !Join
        - ""
        - - "{"
          - "'AttachementId':'"
          - !Ref TgwAttHUB
          - "',"
          - "'gwlbname':'"
          - !Ref MyGwlbName
          - "'"
          - "}"
      FGTAInfo: !Join
        - ""
        - - "{"
          - "'zone':'"
          - !Ref AZForFGTA
          - "',"
          - "'VPCCIDR':'"
          - !Ref VPCCIDR
          - "',"
          - "'hostname':'"
          - "FGTA"
          - "',"
          - "'PublicSubnetRouterIP':'"
          - !Ref PublicSubnet1RouterIP
          - "',"
          - "'VPCSPK1':'"
          - !Ref SVPC1CIDR
          - "',"
          - "'GeneveGateway':'"
          - !Ref GeneveSubnet1RouterIP
          - "',"
          - "'VPCSPK2':'"
          - !Ref SVPC2CIDR
          - "',"
          - "'VPCSPK3':'"
          - !Ref SVPCNSCIDR
          - "'"
          - "}"
      FGTBInfo: !Join
        - ""
        - - "{"
          - "'zone':'"
          - !Ref AZForFGTB
          - "',"
          - "'VPCCIDR':'"
          - !Ref VPCCIDR
          - "',"
          - "'hostname':'"
          - "FGTB"
          - "',"
          - "'PublicSubnetRouterIP':'"
          - !Ref PublicSubnet2RouterIP
          - "',"
          - "'VPCSPK1':'"
          - !Ref SVPC1CIDR
          - "',"
          - "'GeneveGateway':'"
          - !Ref GeneveSubnet2RouterIP
          - "',"
          - "'VPCSPK2':'"
          - !Ref SVPC2CIDR
          - "',"
          - "'VPCSPK3':'"
          - !Ref SVPCNSCIDR
          - "'"
          - "}"
Outputs: {}