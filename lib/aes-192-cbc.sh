#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎL+�@�
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���\E/�q�'�3�C(
6�_����������/G�[IK��v�X��;��1b�e�YksTHA.�jS�jX|��%��5�2(�W�;Xm8Z�P�+)�N懣�$�ޏ���:i3yOk&j��ߟ�9��pNvi#�U$�+w���aY�U~_�b�V���t���j8���p���(5=i�zeW�(HYw���L:W)ܚ�Xm�(s:�����ϋ�%l<�N�eg���iӥǓ�CT��a��?���B���fA]�>�{�NY���7�u?�BO�Z;⪒Gs�יk��E,n��a|���"ʅӼ C���~�E\�U֩�0������1��T�Z}��/����¼X��?�Gˇ��/q�'SS��y���.�!5��E���ɡ�����A{������2r�O�UWT����\�s���������O����}���Cv{��C�D�& �cx"jI��Y䄛��I#C�ڌ�-��*�)�,�%g2`��5t���j�,�t`��tr]X�1�=��U%��W�s6"8C�Ё oV��L��P@� 7���d�O-łi6���)^pq��MPߢQ���9B��l�2��?����E�P���`�NI��L�� O�;��I�F� R�X�qx{���?�m�9�������,��0"�����8O[����JQ�!�g版��op���k�MK<�$�fv���!~�Y՞̷�>&]9`��g d����&��5=ɬ� �"�Z@яC�5%i�φU��w��ާM��*��?��}��<��ʪy��wJ�����R��H���ɴ���0���Ԭ�n�P�k�\��S�6����q�S��˔Q�͠�"�b����tJv�h����>�����k��< ��=�It�2C�{�������3)F�:�C�ο�$9�������,z`�i��9�0��!��$�|r�9�s_�z�4�"l��$����㹕��h�ePι���b��g�bm�a��x�'!M��{���P��,~��斆��Ɇs99`����{�?�p��?s�,!\��N~z�"��"|��!��9cfk�Y�0�77�"(%��:n���6��9	��=��.M��X�X.V���6��5#ͷF}ZEGt+�ۈ3�ʄˉ߁��B�3��zm������1�������l�5�Rd�2��O=�D@����A���?�7W�k!djJ��������7%��CB߫`�� �_v�yA���c�ur��|�G�����tǻэ�0�&�S��У����-�Qe�>�ӭO�L_ _hl�ߨ��j^J*e�J<"�hYB�������v�ծ\��������9y�?~�/���@z P�g9��r�U쾉+r�Z���E�v�Q��A.�n`��������yG�N���[���5W�B�����#��T�C8,^�c��3���v�ҁv#A�J�7A�v�xT���p0`fb
�����%���A�Ą*�%y������t<`��R���{�`�� n��;Wz'Y���	QdE��T ��E�.^�a�w~�"�O��{�$�0�����	�0�����c�c��J��i2���t[�.P�y�9���
w����-�?�Ah���b"�6�.ŢL��z��3@����d��n�ij}FGs��*�"��Fb��v���~�Q��Q������8�b�q\�WӋ�ix�O�q���(6���/GT�����[jޱH�m����:5��[��������=���L�2c�r�ǂVe�	��05Z�mn���]'�9LN��=jP��ը�m�9k�-�9�0�V�<��I����ϖ4�M��lAq�
*�7>�,Z�8O>��f�_�T��p���y�ᴶOY�����<D�rͅ�l�Q�Զ�����
eb���*�jh'���ΣHn� P9ēwb���󐆃cr�gS3P�ƌ��rO$�)[1��y6���C�=e�����MSd:A���p粖�	��;����8`��1c�7s���}ml�%2��DyČ	�D�n4�_��b�ھQ�S�'�A7�e)Y�'S3h��ĒuZT	W�O�n[#�J�$�l���}⟵���\�W�1�4���]M��-�s���|ȩX?8���Qڸ
�B����H�J|n�xJ����"��;�'������t�Bq�c>�;�z1O� ���|`�ʹ��羐(E˒�s9�H�?[��`Z�����,{��֧�m�r�?��fv{�2^�<6���x�Ru���H�%wǄV<� �q���!�w�4���}7~C���})ΞWL��2�p�g���Q��0ZS�"�z/����>�(.O.�O���!s�%�	Ra����9�1�����*=�ͺ�
�g����jv�:\���-�r����dE\�~8J��E�^�������Guңr�m���,�<��/159���şA3�H�+-�'W���|f��m
ɠ������NԎ�#Q�"�ъ{k�m�{└��Fn2�@$�oV�e�>Ŏ{���#ΰ�To�z��o��j-��*Qn�:��.���.BZW����=�Y�+�������.�}-�)Ae�U���]�o��6fVGNnb�I��T����z�=���B�'���m�7�h]��/�&$m�z�4���$��U>�kB�u(�x�?[�0���X���ړ�r"Pul�'��W�����I/�Qj8K�	�x�	L��^�o�?����	�l��p̯���y���[��űᢠ;��ZPf�;� 1���G��
�K��-��\3HZ�χ��3G<[��ʻNn����VG�uA�r���o[�.#�=(�
"�Sp��Ig4���E���k���g[h�p���VS�\
/H� O�ǌv�Y�&2�|�+�8cGX�k���������W��rW��)J{aX���u0l>��������7���(<X�D����(�$���2`r����nڻ�[�=�H#�X8#���`΍d�F@�_��,S�������O�i��9{}�Ma'�C��_"�F�����$@��� �o?+G;X�d?z��'}Œ);�B;t�7�:LYy10��i�s���	����H^4xE��Rk�F]�b���8v��������E�ӕ�LH�nѵ�8�i� �q7,EA��$Ӿ}߃\��`e�BR�牷Pa���"vUb���&5i�]GX�GWk��WDw&�/�����&fG檿"�����mK�4��F=��dƖ�R�;������aK���`[���tb�1�$��Ϗ��Xi�r5Z���i��l��3V��FlR��%�wte(h�:�u@Zl@1�[�������W@��e���0��nK��3���|,�V �����O�;��H�ǘ�����6.9	�>�m?����_��wiu��9袠��h<�P����3uh�^��"-a��btp������H#|%Bu 0gRD��'^>�U0�1{�_���XԊq�[��� ���,jN���=M�mq�]��w��K� p��P���7����i��㑺�d�%O�6����n�U1r`����>au�9����Sz���-��[��ޚř��s��")���TY�[OI�vj��Z!��΍�8����^��5>9�W����̸q�ޅ�'���Q�1o��}���뎘bwd�x�x���91�i�1S!��]R_��HN��[{���^'�:����r�h��#o�l��6�1&�˰XeN,����D	�����d<�x���Ip)��8�ZI�����u�0\9Ȳ�6KE�KA���t��|Y�����o�k�� ��֌ؖ�Zv�zӊ���)gWƺ0�[(�C�8*_�?�Iȗc�'����1�'޵��Ag��mO�ȇ�t��Z���	Je�Iz��#Zd�?��0A�[f�s�'#����s���^�{�!���"���"3 