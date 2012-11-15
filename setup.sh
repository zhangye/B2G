#!/bin/bash

. load-config.sh

VARIANT=${VARIANT:-eng}
if [ ! $LUNCH ];then
LUNCH=${LUNCH:-full_${DEVICE}-${VARIANT}}
fi

export USE_CCACHE=yes &&
export GECKO_PATH &&
export GAIA_PATH &&
export GAIA_DOMAIN &&
export GAIA_PORT &&
export GAIA_DEBUG &&
export GECKO_OBJDIR &&
export B2G_NOOPT &&
export B2G_DEBUG &&
. build/envsetup.sh &&
lunch $LUNCH
