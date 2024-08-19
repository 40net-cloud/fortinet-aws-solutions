//AWS Configuration
variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "eu-central-1"
}

variable "az1" {
  default = "eu-central-1a"
}

variable "az2" {
  default = "eu-central-1c"
}

variable "vpccidr" {
  default = "10.1.0.0/16"
}

variable "publiccidr1" {
  default = "10.1.0.0/24"
}

variable "privatecidr1" {
  default = "10.1.1.0/24"
}

variable "publiccidr2" {
  default = "10.1.2.0/24"
}

variable "privatecidr2" {
  default = "10.1.3.0/24"
}

// Load Balancer Listen rules for forwarding the traffic
variable "test_forwarding_config" {
  default = {
    80  = "TCP"
    443 = "TCP"
  }
}

// License Type to create FortiWeb-VM
// Provide the license type for FortiWeb-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}

// BYOL License format to create FortiWeb-VM
// Provide the license type for FortiWeb-VM Instances, either token or file.
variable "license_format" {
  default = "token"
}

// instance architect
// x86
variable "arch" {
  default = "x86"
}

// instance type needs to match the architect
// c5.xlarge is x86_64
// For detail, refer to https://aws.amazon.com/ec2/instance-types/
variable "size" {
  default = "c5.xlarge"
}

// AMIs for FortiWeb-VM-7.4.3
variable "fwbami" {
  type = map(any)
  default = {
    us-east-1 = {
      x86 = {
        payg = "ami-0b58ac0703e5dcce2"
        byol = "ami-05e8ac4563f8b4ca6"
      }
    },
    us-east-2 = {
      x86 = {
        payg = "ami-04f8b3e8e830921da"
        byol = "ami-00862ba8c673ce070"
      }
    },
    us-west-1 = {
      x86 = {
        payg = "ami-0e7768ee398af9e99"
        byol = "ami-062e4864d41548843"
      }
    },
    us-west-2 = {
      x86 = {
        payg = "ami-05181fd492c3cb02e"
        byol = "ami-03c9a7767cf87803c"
      }
    },
    af-south-1 = {
      x86 = {
        payg = "ami-0977314df557a8af2"
        byol = "ami-0b2baf53bc86cbb50"
      }
    },
    ap-east-1 = {
      x86 = {
        payg = "ami-0b126f74a6c820eb9"
        byol = "ami-0e9b1d38b18ee0918"
      }
    },
    ap-south-2 = {
      x86 = {
        payg = "ami-0418948c03cc32811"
        byol = "ami-047ebd29c7fd2c027"
      }
    },
    ap-southeast-3 = {
      x86 = {
        payg = "ami-095b3b0b39da3b72d"
        byol = "ami-0ffaa7329822248ce"
      }
    },
    ap-south-4 = {
      x86 = {
        payg = "ami-059ff4915a3a989a0"
        byol = "ami-00777bbce5e78ee1f"
      }
    },
    ap-south-1 = {
      x86 = {
        payg = "ami-04a76eaec68f19095"
        byol = "ami-0d6933abf5e6155e1"
      }
    },
    ap-northeast-3 = {
      x86 = {
        payg = "ami-093f4e581ef01c6f0"
        byol = "ami-093f4e581ef01c6f0"
      }
    },
    ap-northeast-2 = {
      x86 = {
        payg = "ami-0b8099aae3e2207c6"
        byol = "ami-0792f880eea5b4ff3"
      }
    },
    ap-southeast-1 = {
      x86 = {
        payg = "ami-0cb711b0a8d86b1de"
        byol = "ami-07a2ca156a477eb23"
      }
    },
    ap-southeast-2 = {
      x86 = {
        payg = "ami-011883ee2e87f2e87"
        byol = "ami-08c2ba4428b1c8e67"
      }
    },
    ap-northeast-1 = {
      x86 = {
        payg = "ami-03ca50811f2671b10"
        byol = "ami-031e6f4ff14dfb32b"
      }
    },
    ca-central-1 = {
      x86 = {
        payg = "ami-0d673612b3dcb13d6"
        byol = "ami-08f16ff1c92414515"
      }
    },
    ca-west-1 = {
      x86 = {
        payg = "ami-0d9623b703a0055ab"
        byol = "ami-0f0211840c8f275b1"
      }
    },
    eu-central-1 = {
      x86 = {
        payg = "ami-07fc575558ec79712"
        byol = "ami-05174ba9ca5b7089c"
      }
    },
    eu-west-1 = {
      x86 = {
        payg = "ami-00f952aa957d05886"
        byol = "ami-01d579f2da9a69fd2"
      }
    },
    eu-west-2 = {
      x86 = {
        payg = "ami-04ef3b450713eb3c8"
        byol = "ami-0f5680593cdd6d30a"
      }
    },
    eu-south-1 = {
      x86 = {
        payg = "ami-05c0c222551a5765e"
        byol = "ami-0af4b5a2a7a68921e"
      }
    },
    eu-west-3 = {
      x86 = {
        payg = "ami-0fe4169f483f9890d"
        byol = "ami-0e420364db9c17972"
      }
    },
    eu-south-2 = {
      x86 = {
        payg = "ami-084bfb1fe60128a2d"
        byol = "ami-0e653ed81828ce23b"
      }
    },
    eu-north-1 = {
      x86 = {
        payg = "ami-0067170d456e9f01d"
        byol = "ami-02badead23b585bec"
      }
    },
    eu-central-2 = {
      x86 = {
        payg = "ami-0cbc346a3cd319e00"
        byol = "ami-055b0a63e9cbad833"
      }
    },
    me-south-1 = {
      x86 = {
        payg = "ami-0d851c03f4ccf7010"
        byol = "ami-0e4537dc665ef51b1"
      }
    },
    me-central-1 = {
      x86 = {
        payg = "ami-01b919ec71eaf4e93"
        byol = "ami-06c0c35909a582821"
      }
    },
    il-central-1 = {
      x86 = {
        payg = "ami-0c633238322d2ae88"
        byol = "ami-03147ba6fad7112e1"
      }
    },
    sa-east-1 = {
      x86 = {
        payg = "ami-0e9a8a948ddae3b3c"
        byol = "ami-0c2bc4df49b970204"
      }
    }
  }
}

//  Existing SSH Key on the AWS 
variable "keyname" {
  default = "OO_EUCENTRAL_KEY"
}

// HTTPS access port
variable "adminsport" {
  default = "8443"
}

// FortiWeb Active-1 IP addresses

variable "active1port1" {
  default = "10.1.0.10"
}

variable "active1port1mask" {
  default = "255.255.255.0"
}

variable "active1port1gateway" {
  default = "10.1.0.1"
}

variable "active1port2" {
  default = "10.1.1.10"
}

variable "active1port2mask" {
  default = "255.255.255.0"
}

variable "active1port2gateway" {
  default = "10.1.1.1"
}

// FortiWeb Active-2 IP addresses

variable "active2port1" {
  default = "10.1.2.10"
}

variable "active2port1mask" {
  default = "255.255.255.0"
}

variable "active2port1gateway" {
  default = "10.1.0.1"
}

variable "active2port2" {
  default = "10.1.3.10"
}

variable "active2port2mask" {
  default = "255.255.255.0"
}

variable "active2port2gateway" {
  default = "10.1.3.1"
}

variable "bootstrap-active1" {
  // Change to your own path
  type    = string
  default = "config-active1.conf"
}

variable "bootstrap-active2" {
  // Change to your own path
  type    = string
  default = "config-active2.conf"
}


// license file for the active fwb
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.lic"
}

// license file for the passive fwb
variable "license2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "license2.lic"
}
