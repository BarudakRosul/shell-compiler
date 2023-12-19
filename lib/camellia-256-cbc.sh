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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў-W��B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}�����@�&|s_�#�u�B��:QTXz�Ы^�|̶׬J��0�R�i�_24�hY��o��m�^alQ-�OTc\4ny��높���������^�� �m�N릁�et�
�FeA�^��	t�MX�{�"��h9�qu�&X�uLp<����q�2�c�;͏��6MF.�����j@�e���n�2e"='M{��}�긥	0s|![��&ϯ3^�s�,~�&�~_5Y����o�%�桦�6���r64��M�L�1�R��%�bY�N� W^�V�#���9L�5��K�_e�߈������  B��۰\����v_� \�Z�.�>��+�6������dV� ^�x*��J�����N8B����G�&W�`��zY�)�34z�E�����k`�������jI���UM��q��,:�	��p�>��+�Gsim$7o�߲�_�����iŶ�c�Z6�r�|w냶%�~dy%D���� S1۷:)уr��ca�c pm�<G-�L�0��>`)���9h������UA7�Se2�u���*�n*I�(�<�
����yt��2��%v�yX2
�4�����eB�]&��e ��X
���b�2?^Gz[����؀��;Hr^���F��"Ĵ^�@������K)R��u���2_��b$[�cJe�h�6+m�0�����<0Ƴ��+�}��zF���r�x����l �,��y��Hڛ �\J+!-,��dH�¦��{�;�&!� �Ȃv�M��I����gN��)qf{ltÖs�[�3�c=���w�����L�x<~���8J���	��L8���nf���̕$�J"g�����G&���*JE^cA+��͒I���~�6�=�C�^��)K�GРi"�R�$9��f�#����y!�Y�
����pQC�Ku�I�A��e/J��*�ϳ*�|���D|6����$�w؁�\�׉�'wA%�#�z_�;��|e��Fk ���l�,�ʇs\s�n=PV��0��;ހ�m{���u�Kc�Wm��:b�Wk6s)��RU��N���QB*UߞxkvW~F�k��xb�G����C�sH��� k��5R4�_*��;��ق�v6Qo�9(�t���K}��"�p0�
���S`N]&��S��,R��֯.��S�����1L,�+��ҔF�ƠBz{]ĨL��w\��C��w��kD*u��jy����b�Pa�����<��/��m+j֋sC�"	�j�=�jW�B��7r��@��Q��%[#/��;�x���W��$
�6Q�&�����*P����Z%̔���5�]١��=��WN�X>������A-A9�ꓶ��a�l�,1����6'"G����R�����PT�S2�۝P-�-���f垐$���}�j�d��jK�1f ��ï��}��(�닦U3���"��-�
4�wO`mN���*���2�O�:��5���o+�����x*�����Wz����o�n��\��� n�.;�_Ϫ�r�_j��F B��W�|�H�]`1�}�?+}Y��~���uJ�
����� ��]F��5�+����	(�(��gL�FQ�������ч�Z��x^��kQ�^��;5b���U�u*=�Y��)�BICq�a� 	�\U�1r�������
f�%Y�
��B�o�#��̩z��꿮8�H{1`���X�����!.���1 �a��&���z�@��������(���~�l�kq7G�
��|"F�Ɍ%�0p�k���-�4�����X�r��I����?��?s��g�E�DC
V�$�f9���ˠ�E�A�E���[U$���p��~�F|>���I����,��Y.���6.��)Q��y��j�K��� ݢ�[��=L�>�����Zζ��m�]ɦ� ߖ_F��b|�,W$l����:H��|�L���c}��}^ɵ����z�T�4��p�w	��kT� �rˈ�-���۲�����4H[r�ˆe���v ���[g
j�1c
cR�o�����o�Z�(�k�1��O�Z;t�P���� �f�|�v���V�Un�؄��켸��i0o>dy�Ӆ�{>xȚc�:�˯TEB��e���Zu9S�sv��)`�_����Z>�C|Q"u�x�w��l�R<:���x�,������*�S�I�Y���[i �W��	6**��O�?:��F ����r*�OO\�W�[dk��Lz(�|���w�?C�+�S�*>.}�0<Sɀ{pYy��?��tuy��1k�诨_�/���o�in6�22���K9�b~�$G/�iQ1���_2hib|N�g����YT�([��@���P�7�o���� |�����Ok
["�������A�8��e)���ݕP.�OD�_���Y�e|��^_cX)�C7�=�f.R���g���\�m[��>��S9�,X/F-��{�d��G����r�.N�GTȅ~�]5X��n.(�����w�}]� ��I��ߊ17��y�A"D�?���O
R�JA�V�%��l�g��#Z覨u9$F5�jMw͐m�&|]�U8�1��.�������6�n��;�p�Az��W�O�*#�_�,��g8W&���p��ƙ�a�E<6�K�$*���V���ƭ+���T�O�wp uQ�Myb�y��&�_��Q�R��D��$&��O��:�8.�p0�G�4\��yg�|�6��<GHef)�o��'�q0=V}T���D{)�Q�����\!Mq�Iy�8�E-&��2d��۾��[Ξ�:}��Aם��:A� 	j�+]�[Ę|����d`��hY�ʓ�1� & ���8���5/L�'�5�+�F�����m�]�H�F����T���ʖڎ����cξG4"�`��xS�qgM#盉48&�?����I�Ĩ���}��<	韩�`��f*��W��<A</Х��>�5�̂�9��bIo���:��{�,���J�D�⎿	�Lb�p0��퍦�1>c~��@��[\��	�2�v!�R�r���3@W��6��So��Eg�d�BG�M�9���`n�O��r7����-�"=�me)�gA�V3�8�A��Pn�4w4��k�����_�<ĉh��Wr͟��	�!�ȍ[��<@SU���No��JK�q�OI�[��%:Z^c�c
��J�~��.��
R�5��,=�a�J�k�
IP!�԰n����ne�I7���� CL��|0PB�w��7-���tR��ܑ��r��`�Q��$�8���&�HJ�
@� L9��ORk�?��ဲ���UFJVYB�d:�[�-R:}G@�V�\Tˤh^�ם"W����-�����cS+����2|qV��\�q����iuE���ޡ���~KP�\ǅ�|�-���F���J�ږ���x%���Hw�-m�p&]ɤ� 	+!,չE��L�h߬[���C }!x+��xk�W���!���o?�*-�F����3���`׉��W�	JF*������Z2+3��*��)�V�z
hԲ�r���5'x�q-9��X�����tL��L�1̱ض,��q&I��րY6��qi��]��~�I���O;O��-�����.?)��G7�Sؕ<����u�_���f(A�ԛ��@���^Пp�ց�H��K*^�F�`�%{���^$u��?<K��[�L-�4]���]��M{	8�� 1�&u9�+���=�k�Z�E�z��8y&p�M�+߳*N�>@�4?�X���}�x����(J��`U�Aȯ#�F�n�sԁ E���n�;�~>����6}�_M��d�"�?}��Knj=xWó���W�F�-[�b�vw q ѾsO�k	Ѓ2����q��t��Ŝ�i��HWj��J�f��F2t�-�~RFS�X-�qTG����̂�0������t+�s���K�