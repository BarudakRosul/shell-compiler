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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!��~�aU�ӆ��J���^�n�ʕ�sӦ��r�6�ಿ��T�a��痭��I��.d8u>*���1TyG٧��~�tꤐ{Nų��'@�%�<�����kD��'�cވ����9k�vy�<�B� so��oM.����{��i�ӧ�����2g,򖊱`E���bt8�)F��E�m/�T��p�x���%�yE�3p[��Q�.M }"H��3PtΊ��I�c��ei�W\xe�$ow��i� �U�:�)Y��6v��Ը1̫٣�� .��x��]~�#.���an�}�������آS� ��+��f�xU쟜�%q��yR����7�p;��7Ҥ_��|0%����K�΢��5�_$�B2�!�����M>	��Dqǝ���ޝx@��e��z��u���J�]��H�UD^(��EO?$R��9�|�E�~�1�>�VV����*�h�X^䦔�n��,#���+��u�N�JO�Z��9�Hd����,kj�J6�DCb+���NS=�Z8Ө�7ll�8�F�|�pE��;!rg"��t�C�6�^��h�@ϒ�)���@�0�YY�J+�U۽-9�������=����$m�vc���ق�݆�E#����]���M��'n��~]�O֙�]-�;���r5�J�1!���aT5z���^��d3��/;�R����"��&�_rWE�sS���k
Pj[~�yFz����~���~2��X����:�nap����)���J�n/��Ԏ?�C��,b?Ja!���Wv@Z����)�n-�(�vB�f!�hnk��0%��]�{�� �D�^�#.�i�Ŷ]��3HD�K�/㻞4����F❴Y�&<�[�e���)�-h���o�`�}��@����i��{�$�h-�ji���B�<�����W�p��k:8��cg�{�{�|��4����B<C�������*��@�zy�m�NJǬ��6HL���p[�{T}�*�FpG�2�{�^���/x���D�@��-��+�Z(=]d�<�Z��O��7�[�WmS�UcKS�Ĺh�s�ӳ2J>������P�b��G��U��g'���ш=oG2;��d5)=�&�Ɣ7�Ҷ<�L*�E���qq4�̓h*8Dc��.������v2iA��'����Ӯ~��]{&�ÓeS�bG����)q�h,T�]vP��ː��<+��cc;7L�|��&1���(�r��B�.����L2��)�-crn���(�Y�c� K��8;�¹�������L!�Sp3�9�@5e�Qx�|(� ʚ^���o��+y9i���f*G�!�e^Giε��Yn���`�.�.�J��=�����bR�k�\�s�&�Y�T���nld?�E��T��.���5_^?��v��>�t�G�Z=
$������9��ܙ'�9K�g�Kcs�Y�,ك�td���c�c�/�9x���E�H��.~��φ�S�#��y��%������}=�.�#W���G��0\2^k}�T��P��9<�YD}We�:��o����}��;"��ҒL��O�����|Vr�KsP;@���C�!Qα��![��Bt�41���F�/�"�������@���E���ߚ2��mz�ݣ`U���'��>E.����$��<�2.�V����c�9K����9���{���X4Y;`0��@VYSN�P�ֳF���O�ݷ�J��>"ّJ@�&�%�4��HvL�y���d������1���u�,n��������>�;�Α�z�����nԿ��	7�5q.P"'���̅���C�j��L%����7��S9��[��G�h�Ė����i�>��(Q��:O�#�r�n܏����0�3#�a-��EŔ�I&���f.�!f��e�zibE�	��Nӡ���nM���\iy�IG�u�LnL�sP{my����6���I0W�m8���Y?`cJ�m{X���i�[��h�'�T��v�� ��(D���)�Wf�%�8d	�T^�p'�L��J��Ǎ(�����$��Ӳ�M��c������zu��5,ٸX�ȟ�Z�b���<n�M�#s[���#%A���x�a�]՚���wE��-D��h�uw��P�]�Jh4/��<���d���'s�JK�n\�+IX�c<kx���E�Wj��Fn�ؔ7D�X��F�b���V:e���3��J��%�7i��BQd#!�5�>�T���@��>'N�����$|�-��p�3�"�{D��E�`G�ɩ7�т�<qH�s�C���3-���'����l�=~�̄��a7�8�<,��
O;��=��0�ǵ�PB��S���yx�
�Vk��}�I�bAd`�
br����Ó��t+-��y��:��Pl���M��>�f`0y�@�U~U��5�m�����!��Q6\���������0��X"3Q��`
g"�C[���u��
��0�G�����%x�4�>"�	���Ō�r�&,�����*S�)�P��PIK�=
�s���Ƌ=��V��<%�T���k`X����2����;u���<j'�����i�|���Цa�M��`ϺŻ�`i��s���nг�������r�B��!���쟶��>�^���" ��5���a�F�[]ܨeFv�KL��>"�h����@�����6�@vtf
s7��d����LbhqX���ETU��R4�#����#:�|��C0o�粹���#�K�}��zQ|�o#�}��:��3�l)Cހ%u�̇�rء�����Y'��t�Q|��Ym춝�j�I��a���$�I���(������>�$_�|s�qq!���Z=�*n����f1M�dL\b,�a�['���cQZT�{�W��ٰ�<��8Q�C�	�ˉg.x�Rb�ݙ�߫�YirE*\�Y_��ܙ���y#�<�:p]����YI�b� ��E����)N��M>�&���Fm�X}�Ă#'���ۓ��ۋ7q7���2�O�ބ�H+b�}Y*P���h�/�����an������r��P�3C���y��9�o�W{䨂 ����3�.���VX�7�gK��^JF�R�Տ�g���?��'��W7*�)�� 8�#'sꞶ�@tU�<\��#� #�͐<����~�$��a�0U�fʘ��+𒤞
|Z�mU��~���6t0�;��Bp bt"�@�8�%=����l �R�F�gp��Y�LLo��y��*_��4�:Mۢ|.	�K�{�Y��7�pO@5��◊��s���
�l�\ò�E��). �)O�.X��-&�kY�΍,�����/��1C<{��u�+H=�A��d�>������' �ӟoz7iHN�uN�l��-g=+���=_;p��?c�@�8tt�7z�������x�	o{Z��mt.����_x����"���I��>,�����r��M�����ҖMb�g��Xen[Q�f�߱��z����6Qy���
�c��g�;�(�',�7��w��&�4f�)Y@�Ӧ�E����~�cJ�}G��{N�zK���[K�w����*P�bIL��!*]m�=�v�H�ۿ߈A�^��w�7-|cg�-��ᑔ���뉭�)V0��<q?F\�	4q�B��/mt!l�4�����0���z2F�t�B��0<<�0�֥]^� ��u�\�rǵ4���3��!*$(~�(��7��&'�����	Fn$C�D�>f���(����o���noCu����a�ubd"�s�i�@Ut�� �{�f"�l�Z�dKW�jسq2���,�fN��Q�cP䶒s
�o�̘>��<#��M��KS�}�&�${�:|L.�@��C/J.UZ��o�����RW�1���[<�g��a���>L1