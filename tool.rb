input = <<~INPUT
  #----------------------------------------------------------
  #  プロバイダ設定
  #  プロバイダ：google
  #  リージョン：asia-northeast1
  #  プロジェクトID(GCPの時のみ)：nttd-platformtec
  #----------------------------------------------------------
INPUT

def generate_provider_code(input)
  provider_name = ""
  project_id = ""
  region = ""

  input.lines.each do |line|
    line = line.strip
    puts line
    next if line.empty?
    if line.include?("プロバイダ：")
      provider_name = line.split("：")[1]
    elsif line.include?("プロジェクトID(GCPの時のみ)：")
      project_id = line.split("：")[1]
    elsif line.include?("リージョン：")
      region = line.split("：")[1]
    end
  end

  provider_code = 'provider "' + provider_name + '" {' + "\n"
  provider_code += '  region = "' + region + '"' + "\n"

  if provider_name == "google" && !project_id.empty?
    provider_code += '  project = "' + project_id + '"' + "\n"
  end

  provider_code += '}'

  provider_code
end

terraform_code = generate_provider_code(input)
puts terraform_code
