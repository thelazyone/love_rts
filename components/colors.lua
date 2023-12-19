local colors = {}

colors.white     = {1.00, 1.00, 1.00, 1}
colors.black     = {0.00, 0.00, 0.00, 1}
colors.dgray     = {0.20, 0.20, 0.20, 1}
colors.gray      = {0.50, 0.50, 0.50, 1}
colors.mlgray    = {0.65, 0.65, 0.65, 1}
colors.lgray     = {0.80, 0.80, 0.80, 1}
colors.red       = {1.00, 0.00, 0.00, 1}
colors.dred      = {0.50, 0.00, 0.00, 1}
colors.lred      = {1.00, 0.60, 0.25, 1}
colors.green     = {0.00, 1.00, 0.00, 1}
colors.dgreen    = {0.00, 0.50, 0.00, 1}
colors.blue      = {0.00, 0.00, 1.00, 1}
colors.dblue     = {0.00, 0.00, 0.50, 1}
colors.lblue     = {0.25, 0.60, 1.00, 1}
colors.magenta   = {1.00, 0.00, 1.00, 1}
colors.yellow    = {1.00, 1.00, 0.00, 1}
colors.cyan      = {0.00, 1.00, 1.00, 1}
colors.lorange   = {1.00, 0.87, 0.00, 1}
colors.orange    = {1.00, 0.64, 0.00, 1}
colors.dorange   = {0.50, 0.32, 0.00, 1}

-- To use if you want for example to change alpha, do NOT edit the original colors directly!
--
--   local mycolor = colors.cp(colors.red)
--   mycolor[4] = 0.5
function colors.cp(c)
    return {c[1], c[2], c[3], c[4]}
end

return colors
