return {
    {
        prefix = '#uvscript',
        body = "#!/usr/bin/env -S uv run --script$0",
        desc = "Shebang line for the uv script"
    },
    {
        prefix = 'script',
        body = '# /// script\n# requires-python = " >= $0"\n# dependencies = ["$1"]\n# ///',
        desc = "Inline script config"
    }
}
