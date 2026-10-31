export REEFGUIDE_REPO="${HOME}/code/reefguide"

alias rg-cd='cd $REEFGUIDE_REPO'
alias rg-ld='cd $REEFGUIDE_REPO && ./local-dev.sh'

alias rg-ng='cd $REEFGUIDE_REPO && pnpm dev-app'
# just a different name
alias rg-app='cd $REEFGUIDE_REPO && pnpm dev-app'

alias rg-api='cd $REEFGUIDE_REPO && pnpm dev-api'

# Database
alias rg-db-status='cd $REEFGUIDE_REPO/packages/db && pnpm prisma migrate status'
alias rg-db-seed='cd $REEFGUIDE_REPO/packages/db && pnpm db-seed'
alias rg-studio='cd $REEFGUIDE_REPO/packages/db && pnpm prisma studio'

# reefguide-aws
# rg-db-tunnel dev
alias rg-db-tunnel='cd $REEFGUIDE_REPO/packages/aws-cli && AWS_PROFILE=reefguide pnpm start-tsx db-port-fwd -c'

# Infra configs
alias rg-infra-dev='cd $REEFGUIDE_REPO/packages/infra && . ./configs/dev_env.sh'
alias rg-infra-test='cd $REEFGUIDE_REPO/packages/infra && . ./configs/test_env.sh'
alias rg-infra-prod='cd $REEFGUIDE_REPO/packages/infra && . ./configs/prod_env.sh'

# Start Julia ReefGuide Worker
alias rg-worker='cd ${HOME}/code/ReefGuideWorker.jl && julia +1.11 --project=. -t8,1 start.jl'
