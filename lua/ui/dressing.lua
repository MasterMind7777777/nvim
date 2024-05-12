require('dressing').setup({
  input = {
    win_options = {
      winhighlight = 'NormalFloat:DiagnosticError'
    },
   select = {
    get_config = function(opts)
      if opts.kind == 'codeaction' then
        return {
          backend = 'telescope',
          nui = {
            relative = 'cursor',
            max_width = 40,
          }
        }
      end
    end
  } }
})

