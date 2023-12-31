#!/bin/bash
#
# Author: Achixz (Citra Bella Rahayu)
# GitHub: https://github.com/Achixz
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5JΧ�"���*f�A-�˻"��Lϒ��)c_kǂ�ݻ�o�-t���
K�����8Ŭ)�'Ds{.����U=6#�ɢu���һ��%�r����{�l�����7:e1噠 2�U��O�N�(�y.zۏ�B�oɎC�~�ԓ�-����NR�$|���؎#K��(-R*o@�З{H���O�T���ʱ��Σ�,�� �[�����܍����I��ȈUc��ݚ�4W���Wi�������c�Łm��C*�&�v�o"$M�$7���pO5�=��Z�h~�z~=!C�U�d�[㒋ź2D*]�;����׃o�*c�%V�X~�9�_!r�2�O�W +ɻ�l_rⷉ���J�N��W\vg~'l�h�?��`!�4�U�Vyz�l���y1�E����S�ǔ�ږ��f{��bk�+� ���땶4,�(^�|��T�6	8��.&,D�IH}�"�O��X>��1��� ��R���D�;))�ķ&jݷ�D%�:jcSx3F�H��]��7䞮Mʺ/�B�.^}}���2�a�G(%Q�MgP�P�rD�m�������u�����O�L>�ߎ���8�w���r��ۀ��8r�+�q�Z- ��n����0G�o%؝1�h��>*+êYO7�gQo���k�K�18]Wٙ=��6}�b��t�� >W�IQ��n��,d��M$���Ţŭ�&ּb���L�4n���4=�u~�����Α�C��F]�m�q��%p(i��5֩����t��xcY�ׂ�3!.KI2ɑ��\S��e䕃d��yK���9j�/x)hi�Ӷh'�{9� �hΞ�<�y�D��\J7��;��n�=E����e�J�#ʴ7�;+)�o��!IU�����=q������oc6׏CV}�3_��t�ɴ�4�}��ǽ�W���V�Uu��f�-��?����W��M��ӅO�|XC�=1�T�tJXE8��4�r/M�� v����?��2��7��A*�Dm0)��k
����æ���4�Z�7ȫ��&�GJ�.c�[-�M[���x"�퉮�X	���8OT~@����-Cw��%8�6�_m���Og"���K�x1`��gч��Y��?����[���ZNC�ӊ�),J�z�vɏ�n�f��VA�t���'�ڹ1Q\@�~��s��R��>6" �E�6DƳ�$���3�� �!�PLq����=1�U���_t�B�����.?A��|\����+G�>���߿�[��I�kCA�(�.��|�y!��n/�Zm�e���\���4r+b�d9*ړ.R0*�-�Ŕ�����+wdO�	�R��*s���%p���сj�n����8��3����J��{�6	'�|���)�������0N��/�rAz��������;i�O���B�Z�����3P�tdn��*%������'{���E�r�����INC�����S�T����{��IY[,����� �B<�	,���͡G�D|�^��4��]�&�V�)������x9M���H2��+4/"
����(UF�gjL�!���Ӗ>}��]�|�پ��B�ENn�����僊�'�_��k���T�0�H�f��L�(�9�<����D 3�������T�I�Bl��y/�K�F��`' �]Ä���,�����6/�q���l_�D��-)st]��J
@<Z�F���wP��%�N�y���Jo���Uv�Hf�H�
��=Z���Mr>��Ɛ�	WGH�ٷ�{��G�	��Z�0���O�A�4A�p9�A��k�4��s�}g�x��_N~ĿP�q\�9#�Fj>���N�H�0o]�!���u��8@W=�l"��a6�k_I@�(53�c�c�֫8Y�?��I��b�`�6�F��K��ٔċVPqGГ1�-Kx�m%2NoP��j2���U���҇��]��\�$��,�";.).M+����~�	��D�QI8/�Ů��Ը�D��F�Ӧh#j������&���T�	��07[Z� D�!�C��	
��a[��ǜ�68yTsgP��D���:�F�
��砝v���!5pK�ny~S����LKz�;?�a*�Ԏ�t��9��iQQGց�SL�t �E6_�6=�>��tzr�yQ��_�Ey�&q��]v������Z~b�Al{q��J��[1xEf{n�n�s�
���W
ڒ�Ƚ�&˽��#����{c0�}gD�v���:��	P�o�fR�D�����k�HCƺ�e|F�'��������H�c�XH�q�A��F�x��}V�g�GҨ7x�NEWjR*����{�ٍ�m�֩Ӥ�d����B�q��Yb��R�i�D}����h���(��E
��#�5�W�\��hz�~-����J�A$����{�ݨ�~\M����yb�q�г�ڔ��P��kKk��
)1i++�Nh<<�0`�`t����mɧ�w�6X�֘�2I�g�������^�����÷�Ђ9v�d��M�����M��[u3i�EODY�F�\��}X�|c��C�"��/�5]ޟ��[T�5���t��٠�Q'�Bm.��1+�o���F�v��,��n�o��Y��J�AŽ�v`ȡ8}R7����;k�t���u�"�j%��1�0�Y^F���GJ-���a���8�j�*�z�U��6r�,!�%|� ����l�8Q;�@�Ć����FK�`/4� ���Ɔk�X"V?�L�#����+D�K������G�!W��������f����n�|e���k����� ���r_��Q�{1ehI1;��?��q���z���
���N� >9jq��	���r���q�l��LS����?�q�X�w�Q�]������92�Ϙc�ހ��%�#O<�����e�)nKe�����2����tES����y����|��O����oz� ̼��`�[���Ro.١H4�o�a%�����{���$��P�7Y��i��H����O�����7a���\ϾM��&DRt��pQ<37O854i��1˂Rg<��T� ���|(�C���Y��.��$<p.�b�����Cg�L�S�x�
6�&\LX�;�fHv�N!1����{b�/!��Iۊ?�h��P��u��^O���P�O�B�{z̰ 0�Кi��U��4��92�6���+G"'�02��PN7)LH��:U���$|�P����n�h�{�V�3�2� ��՛�/�*�Đ�ԘzH����4N��+�;����ߧ�C�^~;���{T~H��Ւuj=��P,I�) ϛWG,����ܨ�\��]��&���
��p��BR�{3�rm�_xc��\8X[Q1nlz��c��1����?��Q�Y����6��hZ�y�v�]�{+�`��h9��
��+煮�������6�/A����cQ0p�XB^5J�#/r�Zn @�Uœ��qY	������(�߿z���W�9�]��+�9d#QOm̴�j�b���4�N*iY��]�3-|��
��P��j�юo
 ���:A�<X��0��*Oe��D<a����f��������^�|��]K����4�1��9����;�G�n2�y�`�o�A�����D�2l�	�[��X�GC��U�dF_~mYw�����O�پOf�Np��	�~�A.m��~֛�w����n+{���H��rF�:���c��Ԓ:�Om��Y��̺��&�����?H�<��h c׷����Ϊ�[�f�Tٴ5��?)h4��AQ�\�#�ۂq*�Q���fUȪA/��n� mu�5�������fuy	�1'>��&�@n0���[q=�f�7��3'<�q���`��X<��J�n'O[�p�6�Ux�k����pZ���%8)�L��hӕ�q�m�9�d����&kݸ���m[f+�S�b䨫w�����]:!u���L�YBn��q�Ĩ�Lp��?�ć�@pW�|&F�Ud`��-3>G=���F?�f!�L��X�f�����Q3�qQǌ����{5�Eדz,�_?�a[���C�'1�7���&�%,x����o�����l�t�,���l�"�� D$��P�5��xSv6�Km���v�d�0��\ޫ�J�9
�m D0ƌ,/J� ��,m;Y0Lv�t8v�,�I:eP�����?[�Q

Y�XȐ�5f�ѓ(T[\�9��(N���$.�=�U|n]���zM��y����`�a����(mz��(��MO�{�I�4�{��zG��v��0
X̢"3�I+�8�ڤ�YؼF��1�1��Fi�������vh�e��U���yE�}[.�[�@��2�ה�7��f�9B<&?�f`osW5n%�i�C���P�T��fe8��IIfH��t�p�<����:���H����EGr�m�& ���(Pj��������+�5Ne�D�I��܈��l3���7tr���7�$o�!�ζ��HrK[��x%�1����x��3PL�f1D���/Ψ���q%�w�	�u㘔���B��vg�J�u��]v-���0Pah16滃�v{���]J 2,H� �*�X��a���Ӏ��*��A��f����I��b�)y�IS�=����S0�Ïztw�*ŷ����wZ�c���!B�Z�>Q�QQǭ\�퇸��o���7��/����g+�� ��"H����#京�m���V"6�M���S)v�fRLt�R�.��à"�4��z�����W�V����� m�H�Sj��4$~��Fj�'C���g$�ɇی]�5jݠ�x5dP1��/�1�ưj ʪdyz~�/[�-�Q����J����E�݄Q�6lP8y���u��e0o.
16�f�Q�G�S�짌��\G�^�߉�e�G��C�$�r���<�]I�逬�Ջ�v�ަm�� y�9�8��L�mT��E�A������Z:����A����3�˛@jZ�#j�4�r/�1�0�.�!j��vF��h�]B4\О/��cx�lr�_�1��ic�T���'��bWP[�Y�EA�!���*��8X^AZd��]L%��v����Ә�8��* ^GE��<�:Lx�dl�5Sq�0�̗;�b������a���[���a�����"�wi��k{#��ӝ�!���ъ�@����6������C�����4sD+%T-ne�J��)�0��3sʋal ��s�!7���#�`b�F����DQ���$Y�B��wQt'f�R�����*�����nc�9��{}S���6�iܫ%=h]�"��W	aΕ��1�=�E�z;	ɋ@txl�t%~_�Q�Z��T^�����3�g�֎*�*$�:����8�]������
���"E�+��G��&`�