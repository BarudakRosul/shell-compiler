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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЍJ�6���2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	�ӢJ�^���j݇׾X� �}���9������!'����N"^1�@�4�'��>�I���g��(4W��9����q��yY`:8����CN1-�$�"5s��S�!G�bqG�4�E����,�Icg6�-�ܒ�q�S���5���ɄY5]MZ,��ׅ2�	��[��y=B�{���q0�4 �K��A�g v-�ʈ�i����S;P	rcӠ�.;�c
�:�P,m�j��4��eB&پ�L�gf�u���I�٭b�M���P�}P�- z/.1��!�]�{�]
g'^��̝��{Sc.�/jy#�x�{������'w�_cSr�)a�螻GDĥ/�Ϲm�7�+��e��uBY3#L;3/m�>�)�Lu�E'�H��}��1��;�N�Hf��0N�xeDJ�#])�II�	��s����^Ӭ�\L��$� T�L �v��ҌJ�9�94��PČؘN�B�����ٝ+��T����h���n�1�玷��R������S P�!��¥W��GjM�1`'�#=!	g�-np�����T�s�UQ��g#�]ؽz"�̔K��u�s^���A ��Z�fd�%$(u���o~LS���Jn)�;�Z
����_��R�@�����uɘL&pLX���d#�����T�P�{S���i����������Mkܚ�Ih��T�Y��ݻ|��̲
��&�kU,�O��f�p��w-�������L��
�������I.��i���|!U0RSҶ~��nK�M�7#��r�,�*4�㿨ǘ%�.�k��W�?���������a�2�+�EYhȤpyu@s	yڞע�>(��0çy��?���
oKn1��_#�S��	�2���!�蘃j�!�y�f*���ˏ�pi|�#�aJ�-p|!Y�����;�����E|����eeAB�@Ҝ������$2��!e�ŧ��g2�%ă�ѥC���}�o��Ə_�?	jAt�5��;��n7m{6�UR�Sf��ht3I$~c��V�b'��֒@Z�wq�⿶ ����� �oX8O��z�G��t�t�&�e%Bfj����4��RB熌����/k���i�A��#��n�-R�L�֤�q׃�\}�O��H�!U�*ڮ8�[��7reF�����M�E� �� ��|RbQE��]@]/dl��3d�e����@(�������q��+	�%=����On`R+s�Ut"R�R<5�5 ����@T,���!uR̺pZ���p��~6�>	��V$\;��㫼Ų�b���R�1�!�J�<ȵ�!>��$L��SR�<���
p$��9�����8�xD`��[����^|V�ߥ��ѤM�� ��H�xݪ����(, a%b}���i�~���0_�P�=P�U�A( �XajlU���4��
0���Ʈ`n��[ڛȾ}M&�W�'#�댹����Ol+������
�_s���>J,Dcj���9s}y�ív��^D/�^Z�:Br��m\H�_�mdt����+��КF�
��t�����B�U��V�ȒMw�{�Q�)�TE>���7ƻ-�0�F.G�,�5W�uc&�(��u%G�����"���t��OF;����l�5�����o%8�h#�p,}��?m��IE^�5�m!�%����Fط�%Cu����QB�v��k��f�n�:6����B9�
��*B;�N�9g^Q'��Fbrro�u�4-��e��qOl��@��dL:��N�:J.���i^1p�ǋn컫�r>���u+_��t�����,������w�)��A@b�(o���j����v�s�c���S��*M�K�l��1GĚ�U�mF	^�^�jo*'M�$�# �Ź��*�bz���i\�j�-����b����v$�K���#��|��"�Fb��/
����t�C�л�7��#)�������3��_|�(2'9��֗Y���8q��j�*�i�/,ȤٖI���n�|?ӭ��^G��'��tkM�Wn	�����+d����;
�2Q�[c)_wT�q?+0�Y�I��d�ΣD�,F	.�#_XW����k ���� �];�]�ԣ���&�;�;�
�`
�T��:%�������T���U>����_�Q_SA6��R��z/>�?�;�K�#��#Wz��R=.\6�+�I�
��w=cO��*EL ��)IF;�ձ3A�r,��nOX����i��~+Zt�S����x��UK�:�IM�lz����xQ2'�����$��	�I����1�h��^������`>HF'+�)�
�������[�l��0-��Y�:�0����/���NC���HRQ���j��J�n"�"�4�[��7c�i��VZ]���_�LGQ1."aZD\��M֡N���$�J��,�C֯	~E���u8��\IO_�QAv.7��PX���.Y;r�Q��/+�(����ꌈ?a�*^�*bЩ��ړ�A�e�F4�J!y[�ga�Ôu��jmA�9����lG�SM�����CWjw��2�?��֑g�Gά��@\F
�L�3�8BD���4N��E�'�fo+0Z�?g��O�Ԓ��])���,I�	���Һ@�0����O2� �,�2f׽��m�k2�I	���6v����i�)���
dD��Xq����o�RM
���J�_�?�|˞�:0��R�E��7�W��C�S ؽ���(O�X�6�)�$��h�/�f I�pa�"vi���Z��Jh�����U�*� �~u�u�{�ؘT�*���T�;�A���y��#�B���[&�L�$	��߀w�6s9$h�c��%��\w�07��]K���ژoot��C��9�_�Ŝ��� ���[��}	f�{AA��]���� {g�Vu��)rj	��P{�_SG�D�)W˂aH�߈T�)A松ٽt�����=�����slU}��N�rd	�9�ɳ.�� Φz)��_g#{���&�`�
ژ��Ȋq!#4�V�7�1݁����xA+|��ޯ+���qϳ�R��V�D!��R�pA� �L��́����Y�m<ĺe�
[S9P��!�26���bj,W\��;e+"& !bz�%�.-��:,��,����<E) ���x*L+ �5�+#tQV�m�oT)��P�>�(8��z)�=�{��	"��?�����Ft��m�O�.�칫�)���	l1�Kǲ�mn���\wY�_���������.���k{��p���͢Ս�Se�~
b�,���7�%n4h�F���~:G����PV�.�`�����Y�<���ϑ��va�)�WB[��$��=у����)�O��+�|�($��C˖�����J�bV�-2!W����m1ޓ�n�䦷U q��j�$y�?k���gĵF}|���v�*I4Q=���@���@2��_",λ����r������|`� T̞��[2�V7Ar!G���P���Zye�֫ӈ%��K]΁)|�b܎l�"=���T������v�Շ�2��g+�SI���4���j�7�\"�캖Gm��"�_����RH|W�hp��[���9��O�Ȇ���9��}�&��=�-�Fo����i���Y0�m��R������r�uÁ�T\�C���=E+���;j���Ց�I5��J�V#���ŵ�c�l�c>���fv7u_q�4��9�c#�����GQ]�G��<�
'�#v����RA_�f��+�YL�mx��h��p�ְ��ZP�V!�qN6=��KE��H��=R&8U��T�~���-��!�Μ]
"�z�����V������A�8����W��;-���8r�Z�O���O��(�s;���~�i���.�E<nH�����k~dK��P�h�7�-=�ʿj`�-��Ip��|��fw�J��z�j��{.��'E6I2�.��6���$9�)�0�-���{R6b8sȦ'� ��B��b1p���ծ�Pj^�ˢ���#��#Cf