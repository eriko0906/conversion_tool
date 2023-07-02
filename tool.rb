def generate_provider_code(provider_name, project_id, region)
  provider_code = 'provider "' + provider_name + '" {' + "\n"
  provider_code += '  region   = "' + region + '"' + "\n"
  if provider_name == "google" && !project_id.empty?
    provider_code += '  project = "' + project_id + '"' + "\n"
  end
  provider_code += '}' + "\n\n"
  provider_code
end

def generate_vpc_code(vpc_name, provider_name)
  if provider_name == "aws"
    resource_code = 'resource "aws_vpc" "' + vpc_name + '" {' + "\n"
    resource_code += '  tags = {' + "\n"
    resource_code += '    Name = "' + vpc_name + '"' + "\n"
    resource_code += '  }' + "\n"
  end

  if provider_name == "google"
    resource_code = 'resource "google_compute_network" "' + vpc_name + '" {' + "\n"
    resource_code += '  name   = "' + vpc_name + '"' + "\n"
  end

  resource_code += '}' + "\n\n"

  resource_code
end

def generate_subnet_code(subnet_name,cidr,vpc_name,provider_name)
  if provider_name == "aws"
    resource_code = 'resource "aws_subnet" "' + subnet_name + '" {' + "\n"
    resource_code += '  vpc_id   = aws_vpc.' + vpc_name + '.id' + "\n"
    resource_code += '  cidr_block   = "' + cidr + '"' + "\n"
    resource_code += '  tags = {' + "\n"
    resource_code += '    Name = "' + subnet_name + '"' + "\n"
    resource_code += '  }' + "\n"
  end

  if provider_name == "google"
    resource_code = 'resource "google_compute_subnetwork" "' + subnet_name + '" {' + "\n"
    resource_code += '  name   = "' + subnet_name + '"' + "\n"
    resource_code += '  network   = google_compute_network.' + vpc_name + '.id' + "\n"
    resource_code += '  ip_cidr_range   = "' + cidr + '"' + "\n"
  end

  resource_code += '}' + "\n\n"

  resource_code
end

def generate_vm_code(instance_name, machine_image, machine_type,subnet_name,provider_name)
  if provider_name == "aws"
    resource_code = 'resource "aws_instance" "' + instance_name + '" {' + "\n"
    resource_code += '  ami   = "' + machine_image + '"' + "\n"
    resource_code += '  instance_type   = "' + machine_type + '"' + "\n"
    resource_code += '  subnet_id   = aws_subnet.' + subnet_name + '.id' + "\n"
    resource_code += '  tags = {' + "\n"
    resource_code += '    Name = "' + instance_name + '"' + "\n"
    resource_code += '  }' + "\n"
  end

  if provider_name == "google"
    resource_code = 'resource "google_compute_instance" "' + instance_name + '" {' + "\n"
    resource_code += '  name   = "' + instance_name + '"' + "\n"
    resource_code += '  machine_tyep   = "' + machine_type + '"' + "\n"
    resource_code += '  boot_disk {' + "\n"
    resource_code += '    initialize_params {' + "\n"
    resource_code += '      image = "' + machine_image + '"' + "\n"
    resource_code += '    }' + "\n"
    resource_code += '  }' + "\n"
    resource_code += '  network_interface {' + "\n"
    resource_code += '    subnetwork = google_compute_subnetwork.' + subnet_name + '.id' + "\n"
    resource_code += '  }' + "\n"
  end

  resource_code += '}' + "\n\n"

  resource_code
end

def read_input(file_path)
  File.read(file_path)
end

def write_output(file_path, terraform_code)
  File.write(file_path, terraform_code)
end

def parse_input(input)
  provider_name = ""
  project_id = ""
  region = ""
  vpc_name = ""
  subnet_name = ""
  cidr = ""
  instance_name  = ""
  machine_type = ""
  machine_image = ""
  
  input.lines.each do |line|
    line = line.strip
    next if line.empty?

    if line.include?("プロバイダ：")
      provider_name = line.split("：")[1]
    elsif line.include?("プロジェクトID(GCPの時のみ)：")
      project_id = line.split("：")[1]
    elsif line.include?("リージョン：")
      region = line.split("：")[1]
    elsif line.include?("VPC名：")
      vpc_name = line.split("：")[1]
    elsif line.include?("サブネット名：")
      subnet_name = line.split("：")[1]
    elsif line.include?("CIDR範囲：")
      cidr = line.split("：")[1]
    elsif line.include?("インスタンス名：")
    instance_name = line.split("：")[1]
    elsif line.include?("マシン・インスタンスタイプ：")
    machine_type = line.split("：")[1]
    elsif line.include?("マシンイメージ・ami：")
    machine_image = line.split("：")[1]
    end
  end

  [provider_name, project_id, region, vpc_name, subnet_name, cidr, instance_name, machine_image, machine_type]
end

def main(input_file, output_file)
  input = read_input(input_file)
  line = "#----------------------------------------------------------\n"
  sections = input.split(line)

  provider_name, project_id, region, vpc_name, subnet_name, cidr, instance_name, machine_image, machine_type= parse_input(input)
  
  provider_code = generate_provider_code(provider_name, project_id, region)
  vpc_code = generate_vpc_code(vpc_name, provider_name)
  subnet_code = generate_subnet_code(subnet_name,cidr,vpc_name,provider_name)
  vm_code = generate_vm_code(instance_name, machine_image, machine_type,subnet_name,provider_name)
  
  terraform_code = line + sections[1] + line + provider_code + line + sections[3] + line + vpc_code + line + sections[5] + line +subnet_code + line + sections[7] + line +vm_code
  write_output(output_file, terraform_code)
end

input_file = "input.txt"
output_file = "output.tf"

main(input_file, output_file)
