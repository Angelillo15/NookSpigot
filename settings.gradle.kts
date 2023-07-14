rootProject.name = "NookSpigot"

includeBuild("build-logic")

this.setupSubproject("nookspigot-server", "NookSpigot-Server")
this.setupSubproject("nookspigot-api", "NookSpigot-API")
this.setupSubproject("paperclip", "paperclip")

fun setupSubproject(name: String, dir: String) {
    include(":$name")
    project(":$name").projectDir = file(dir)
}
