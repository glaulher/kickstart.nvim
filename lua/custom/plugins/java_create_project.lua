-- lua/custom/plugins/java_create_project.lua

-- Cria o comando "JavaCreateProject"
vim.api.nvim_create_user_command('JavaCreateProject', function()
  vim.fn.inputsave()

  -- Lista de opções
  local project_type = vim.fn.inputlist {
    'Selecione o tipo de projeto:',
    '1. No build tools',
    '2. Maven',
    '3. Gradle',
    '4. Spring Boot',
    '5. Quarkus',
    '6. MicroProfile',
    '7. JavaFX',
    '8. Micronaut',
    '9. Graal Cloud Native',
  }

  -- Solicita o nome do projeto
  local project_name = vim.fn.input 'Nome do projeto: '

  -- Solicita o Group ID e Artifact ID se necessário
  local group_id, artifact_id = '', ''
  if project_type ~= 1 then
    group_id = vim.fn.input 'Group ID: '
    artifact_id = vim.fn.input 'Artifact ID: '
  end

  vim.fn.inputrestore()

  -- Comandos para cada tipo de projeto
  if project_type == 1 then
    -- No build tools: Cria a estrutura básica de pastas
    vim.cmd('!mkdir -p ' .. project_name .. '/src')
    vim.cmd('!mkdir -p ' .. project_name .. '/bin')
    vim.cmd('!mkdir -p ' .. project_name .. '/lib')

    -- Cria o arquivo App.java
    local app_file_path = project_name .. '/src/App.java'
    local app_content = [[
public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello, World!");
    }
}
]]
    local file = io.open(app_file_path, 'w')
    if file then
      file:write(app_content)
      file:close()
    else
      print('Erro: não foi possível abrir o arquivo ' .. app_file_path)
    end
  elseif project_type == 2 then
    vim.cmd(
      '!mvn archetype:generate -DgroupId='
        .. group_id
        .. ' -DartifactId='
        .. artifact_id
        .. ' -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false'
    )
  -- Adicione os outros tipos de projeto aqui...
  elseif project_type == 3 then
    vim.cmd('!gradle init --type java-application --project-name=' .. project_name .. ' --package=' .. group_id)
  elseif project_type == 4 then
    --  vim.cmd("!curl https://start.spring.io/starter.zip -d dependencies=web -d type=gradle-project -d language=java -d bootVersion=3.1.0 -d groupId=" .. group_id .. " -d artifactId=" .. artifact_id .. " -o " .. project_name .. ".zip")
    --  vim.cmd("!curl https://start.spring.io/starter.zip -d dependencies=web -d type=maven-project -d language=java -d bootVersion=2.7.5 -d groupId=" .. group_id .. " -d artifactId=" .. artifact_id .. " -o " .. project_name .. ".zip")
    vim.cmd(
      '!curl https://start.spring.io/starter.zip -d dependencies=web -d type=gradle-project -d language=java -d groupId='
        .. group_id
        .. ' -d artifactId='
        .. artifact_id
        .. ' -o '
        .. project_name
        .. '.zip'
    )
    vim.cmd('!unzip ' .. project_name .. '.zip -d ' .. project_name)
    vim.cmd('!rm ' .. project_name .. '.zip')
  elseif project_type == 5 then
    vim.cmd('!quarkus create app ' .. group_id .. ':' .. artifact_id)
  elseif project_type == 6 then
    vim.cmd(
      '!curl https://start.microprofile.io/api/1.0/project?groupId='
        .. group_id
        .. '&artifactId='
        .. artifact_id
        .. '&mpVersion=4.1&supportedServer=wildfly -o '
        .. project_name
        .. '.zip'
    )
    vim.cmd('!unzip ' .. project_name .. '.zip -d ' .. project_name)
    vim.cmd('!rm ' .. project_name .. '.zip')
  elseif project_type == 7 then
    vim.cmd(
      '!mvn archetype:generate -DgroupId='
        .. group_id
        .. ' -DartifactId='
        .. artifact_id
        .. ' -DarchetypeArtifactId=openjfx-archetype-simple -DinteractiveMode=false'
    )
  elseif project_type == 8 then
    vim.cmd('!mn create-app ' .. group_id .. ':' .. artifact_id)
  elseif project_type == 9 then
    vim.cmd(
      '!mvn archetype:generate -DgroupId='
        .. group_id
        .. ' -DartifactId='
        .. artifact_id
        .. ' -DarchetypeArtifactId=graalvm-native-archetype -DinteractiveMode=false'
    )
  end

  -- Abre o diretório do projeto
  vim.cmd('edit ' .. project_name)
end, {})

-- Retorna uma tabela vazia para evitar erro
return {}
