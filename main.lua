-- bootstrap the fennel compiler
fennel = require('lib.fennel')
table.insert(package.loaders, fennel.make_searcher({correlate=true}))

-- Jump to our fennel main
require('fmain')
