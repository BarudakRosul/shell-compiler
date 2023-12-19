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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎCK�kC�
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���\E/�q�'�3�C(
6�_����������/G�[IKH�Kd�gk`/v��b4�Xs���:&K�2d!v�w����@����x��<Ծ��c`��	��ԇ�����P��Z���Y�Vs�!_�+� �Z�G��
v
+́h��k�ݕ�!��@C��*X��Gtܖuk�@���C�F���Ϛ��p$t1P�VL�j�
���������6���7;��ۓs~%�F�Vq�Z�H�t����=2tH[�����'J�{���W���������R6�s2��5��C��W���{]��	�$բ�9O� �Nc��h��M?n��������z��u�dVh�w����� e�愶�#\���u^s�m���V0���1��`5?U��4�%coK���q4~ D��SgSl��V/Uz#ۄ:
I��r�Z����B��)GS�XdU$�O���D�kŊ�gю�����)�o����{�����zS�J�?OQ7�����t�&�059��t�7����jM�U tw�2y�=��u�$�-��#%˸���z��-�'A+��ȲB� ���dhOK�`W$�[��XEۻ��E�6C���O&d��4��P_pӰ>�|���4�F,�|ʋ��۲+�1�+n�ͣe��O��}�E3�o`��o=ŭ[�o\m�BN�FKTԞ�-�P���r+�!���0�Q):���)�6�i0A㫧�7�������?.M�T�<� 8�m8?>j2�I.x����!����z=-��	����h�� إW�P�C=[� ѐ�J2Jj=e�H�M���ھ�T�Ep�,���n��U��ףq�@���.m~8����f	q���f#iϴ��6�W�\���YR|��-$):��r	n��(K��0p>7%��sB���q�cv����e
���Vv�H����C�*���
��������U�Hf�1҅{�����0�1�9�@�BF��L2$?D��C!���m��vtQb%��GA�I�,Z=��	��Y�����(r����M j���&�*�=$ڊb�FZ��rn���͢7��@|��$�U��}; �H�U���]Ο0Ofx	�oԇ���p`�.�X��p�e�q�<�EvW<�ئt$<E���s0������.��U�ܢ��H��(*oi{yp�xD��յ�X��m�`�r0a
+� ǎnT8�9�ɑk�Ϛ�N���zi��Ym�d����D�B��I��kK@��϶9�L)_,>&Q?�y6�a�:�,�5)�u��57�*,A�D.q�5f1�p,�N8�`�g�9��s【N��7��A���A�T΅?�Y�[��;�t?���;N�WU)fW��	�K�ʿ���ǽ������p�w{�G꛴+vu�Ѿ�g5�|�v~�����٬f ���!t�p���|b��^����[�t��Vq/���祸�|3�j�W���@?�]TI
���X�aI��V��ܐ���K�ȩ��xWO^��/s�'A��-�(8�Ӳ�Fi�c�U�SɎF�=����o�
iN�V�/�(3v;9]�w���{��(U5�3^煕�K���%���:�����JהM��gZ*O]���Kp �yI:�oYZ�?CA��&e���\r���J��I�,�0������-�$����-'��7>8�����v�MQ�/S�hJZ{�Xn�vJ����_&��<��	��·���\|9G=Ԉs)�1y�I#�����c�ZQ����a{�F~��P�/_=��7�9'4@"��9��9]PkR�����J#��EH�$��>0��:�f�`(��HoW�н��s~�5?u����ﶇ�E�T��4#c����y�v��)L�]� ���"�t9V�j���~i�f1��׹�K���B���A�fMA����ЧҸ��v��+I"Ä{}�,
��pK���Mi$�o��y{�1N�;	�*�z��}ӡp�T��Z�ḏo�]
{|�����D�{N�zp>	S�%E��(��)+4v�;�Iv{�B��hl�=������R/���W��=lJX�����������Q,���xPca5���X�+�D��-�cLS��E��"��A5k��R�vQ��n�w�=Q���I��6�,���M`cq�d��NZ⮁z��|vq��ھ���c;���o|��${��,�	Јp���R�5H��u�h������F�S�J��ާr>���5����5���|X#�>_B��텏��a- �K����阋#Z�t�f��=(f�Df��c4���ٙL{8q�7v���K.t�h�(/�Ѣ4x!�2�VO�Q����jR@���S���cm�Ǹ}-�[�O�{
Dg���2����>�̐���z�1�D �1B��N~��=�9�w�P�J=��JB �!E�܊�YCy����x���r§�� �z�0��r�=�Xz1hn���RSbs�/��|��4$Ǭ\ʕ��K+���P��F���5�VuUА����V�|���g�*���*r��%�tN��\G�NV�-��D�\�yeUQ¯ɷ��q��@E�,���AQ&_��1�-D�H���p�zu�~�<sa���p�t+�L@Cc��^���u>hva5_O95��èz�Z�GU�9�AM=�o�����NyG�{���0�Q�9�#�����S�*���Z �������)Oh?�O¬���G|P�}�i1Ԧ؁E#�	���rz�}L:���}�	�uF�S�j;��a�q!�t'���1�)�,׬��s��S�o�A�0v�d�M���xK�ϮQ���_3�HI{�~׋��`j�͘J�o:������[%0�q��]�Xӊ���N�
��h��GIc5�{�V�{D��Vvjs�ϡH}&v1P�G�u���zT]�.P��w%W?�n��!��
���E��yQ�5N�F�h!�l��}cU��R����[]������:�3İ�ח��}A�&ePA��mм�}e.���w���t�;�B��Za0��8�Z'~�Ik�ĭ)�|t��T|�݂���|%|��R�ߏzF�H�أL�!W�K�6V��Rz7�Bg�m��l,(~jm1+�����w��KJ6:����N8Nd�e��ɰ��d;|�%V+�%�o.CN��T�����m���Z�F���˓K�¹*`�6���IP� L�M���kP54��l��PVN��e�����Nb��4�'A>��6�#�>�+4� ��K� n�v^W|+����=��f�k�v��]%��j�E����I��6�ɵ���E�=쥍4Y%+�Pƕu)z���<�=>���cKh\ђ~�5�r��ZoW�э� ��C�00�>O��Lў��� 8/��~��f��Deq�=�SGhs�E�,������AE�:� ۚ_�E�0�4=w��hc����$�|�{[*��#L�K���z��0A<E ��
�+|���Ĥɬ:+��E�B8gh?��\��4����֎�C�:bh�'AӮ�=ݯ|���z���o�]�?����Σ��u��4�3 �B/>f0�OqV��l.Y�\�����Q�Q��v�ѿ�M��Lo����p�avRd$�"}�py���m�����&m��C�M=6���D\{��7�����T��[�:H��F��M0)��s7�U[&�a�<��9�@�Q�}�i�@�&8������3���Ɓ���r!˲��N��;��)a>�J`��C�hϳ�]XV͏N�¶d�']&qqxW�D����%Y�(&i[s3
���3 p�
���� E���i���Ѣ�LI*=���E}����h�á�0���y���f��U�!e�����@��+Y1Y�FˏԬKA���a"Tu��P����J�_w5��	U/>��4�"S6�,]����i���