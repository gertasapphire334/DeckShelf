fn main() {
    println!("cargo:rerun-if-changed=assets/deckshelf.ico");

    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("windows") {
        let mut resource = winres::WindowsResource::new();
        resource
            .set_icon("assets/deckshelf.ico")
            .set("FileDescription", "DeckShelf")
            .set("ProductName", "DeckShelf")
            .set("OriginalFilename", "DeckShelf.exe");
        resource
            .compile()
            .expect("failed to compile Windows resources");
    }
}
