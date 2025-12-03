return {
    {
        prefix = "logging.basicConfig#stream",
        body = {
            "logging.basicConfig(",
            '    format="%(asctime)s - %(levelname)s - %(message)s",',
            '    style="%",',
            '    datefmt="%Y-%m-%d %H:%M",',
            '    level="NOTSET",',
            '    handlers=[logging.StreamHandler()],',
            ")",
        },
        desc = "Basic logging with StreamHandler",
    },
    {
        prefix = "logging.basicConfig#rich",
        body = {
            "logging.basicConfig(",
            '    level="NOTSET", format="%(message)s", datefmt="[%X]", handlers=[RichHandler()]',
            ")",
        },
        desc = "Basic logging with RichHandler",
    },
}
