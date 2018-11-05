#
# Append Nerves Specific environment variables to the SDK
#
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

NERVES_SYSTEM_ROOTFS_DEV ?= "elixir-embedded-image-minimal"

do_install_append() {
    # create Symbolic Link
    ln -s toolchain/sysroots/${REAL_MULTIMACH_TARGET_SYS} ${D}/${SDKPATH}/staging

    append_nerves_env ${D}/${SDKPATH}/environment-setup-${REAL_MULTIMACH_TARGET_SYS}
    ln -s environment-setup-${REAL_MULTIMACH_TARGET_SYS} ${D}/${SDKPATH}/environment-setup-nerves.sh
}

append_nerves_env() {
    script=$1

    ERL_DIR=${SDKTARGETSYSROOT}/usr/lib/erlang
    ERL_INTERFACE_DIR=${ERL_DIR}/usr
    NERVES_SYSTEM=${SDKTARGETSYSROOT}/../../../

    echo "export ERL_DIR=${ERL_DIR}" >> $script
    echo "export ERL_INTERFACE_DIR=${ERL_INTERFACE_DIR}" >> $script
    echo 'export ERTS_DIR=`ls ${ERL_DIR}/erts-*`' >> $script
    echo "export NERVES_SYSTEM=${NERVES_SYSTEM}" >> $script
    echo 'export NERVES_TOOLCHAIN=${OECORE_NATIVE_SYSROOT}' >> $script
    echo "export NERVES_SDK_IMAGES=${NERVES_SYSTEM}/images" >> $script
    echo 'export NERVES_SDK_SYSROOT=${OECORE_TARGET_SYSROOT}' >> $script
    echo "export REBAR_PLT_DIR=${ERL_DIR}" >> $script
    echo 'export ERL_CFLAGS="-I${ERTS_DIR}/include -I${ERL_INTERFACE_DIR}/include"' >> $script
    echo 'export ERL_LDFLAGS="-L${ERTS_DIR}/lib -L${ERL_INTERFACE_DIR}/lib -lerts -lerl_interface -lei"' >> $script
    echo "export REBAR_TARGET_ARCH=${TARGET_SYS}" >> $script
    echo "export ERL_EI_LIBDIR=${ERL_INTERFACE_DIR}/lib" >> $script
    echo "export ERL_EI_INCLUDE_DIR=${ERL_INTERFACE_DIR}/include" >> $script
    echo "export NERVES_SDK_IMAGES=${NERVES_SYSTEM}/images" >> $script
    echo "export NERVES_SDK_SYSROOT=${NERVES_SYSTEM}/staging" >> $script
    echo "export REBAR_PLT_DIR=/usr/lib/erlang" >> $script
    echo "export CROSSCOMPILE=\${TARGET_PREFIX%-}" >> $script
}