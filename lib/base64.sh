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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Єii�u�o��<��Ҥ<���/��HBt�.�":� ET������K�.�c>O,a�v+�Q���SP:ݮ3zǃ�8��@�Ƽ���u��T�cR��0�m��h_���&���p���6V���&�-у��o��!����^T�u߹��R���M���-[yp���?}�^���ub����EI����u#Q�<�#�xo�N�uZ\��N�u~�D�Z@VY�.�CHY��&Ѝ+f��Wn�nfuT�EFۀ���plw����1���l:ܥ��'>�$�^&=�Z��m���q��ۙ��I�D���.���Bg�.W3.�m�O��=�sǱ�YO�U�J{>��6��*H�$A�=4��63u2K��x�\��[��%x�P�v{%��H>���K����(4t��q�Q�R%͕�~���ϧ�ǉT�U�!����x;�+c,��:��4�ǻy�IvR�>�-�T@�E�I������M��	̍�,��xJ4P����V`ѻm)��%���իy��Oo��.[)7�4J�W w&��r��=�Jf��N�zy{�ѡ��QB�*+P�8�/�`0���*��NG���{� �VfN� S��pLe�R����/�{u�GN�B�Kȁ�JI:��d�//<?��{Z1a� ��2|�:�6FBf/�*�Nj&�i�'��w�T��c
	[����K�O�g�[��/����?�8��q�㹿��4{��%\����Q0��>O���C�TM���&{o.�H���]�Y>�o��6 Q��A?�p��� 1:�r�>�ߣ���8�qn�ɧL\@�<Yx��(�:���pRh�� ����4*%�^�
X6_�U�O2�s2�����x�n@V�3����j��z"�)߯�5��1=#8�W-��Q�,@���H�7Y;��խHJ0>^�{rz��g��@�-�c6�*4�Z��1Ź�U&
�F"���R֫����(ۉ�#��}q)<1\/��?'J\�L����SlV���?�	n�t�g�����8���R��se>v���;��E����z9�Թ�ɸ��1�\�6DD�6�n:�r�x8�I��O?�4�������y��v97;���7l���e�a�q����~�D�|/�	�6
���;0dq(�<xʘ����w��)W����)�+���<��[;���~�~�fM���l����G��gb���SY�Dc��;�j3��	����䇪�O���	�F����JVy �J�)�)����ȫ��Rb������[�r%K(��{�Ŷ� ǡK��5e���^e��#����"� 5��M߃ �7m�wO�����`h����Ĩ_h������p���lt�`~(�W @���CRg���RyuKJL�5I%8e�䵲RZ/&�! �&�qU�W��ir\=VS�%Gz)6��_�e���őt�K��wfVȼ��C6�	�մ�1���w�r:�u�@�k��-p܏����>bD���}P�c��c#�-�'�s��U\�o!�_��xС�®m�6��z���`���i��<����E���ZRQ���O4�Ѿ�,��ʨ��E8$V��>�b��
Yo��B,{	Pܣz5K�:�_�+5���
�K'՘�%�ϳ�En�+ҬW��ʖ� �Eʔ��X�:�4�ZR	�|�lp�"��X�t���چ"8*Qu"�ȸz������1=lV�*W��L�o��{�!;`�u�Ց
�U��P{����>9j��7Qㅗ��Df7��h�2 	ĝ+{��JA���I�k�D~����/n�DE�f֔�L�$1s,��"�7�n�į�3	��c�]+)	��E6�Ї���N����w�Q��u�2/2q�i[:�̅�˕��p	���>�X�lC�`�_��l첻��}N|Gτ��K$�I���^�����j��u�*�����p�N�(��œ��<�ʇ༯Z�C'�$���ơ�K�G��)hG�͡�*�^s��+d���͹7|'�k&H3|��c�*I�X�\���}���6����?�?��,�?7d����Q��3��ؔ���	��DXSu�`�]*#��,��h�����Ն�k��� I��E���u���O�bl|��4!���	�އ|M9Y
ωF��#���T�? ������9��ݥ�w&�&O�^���匏֮�T<C��,���Z)��ש�>��{�Ah�P�UO�v�h�=��b)�um��d����s�1��A�=W����#)+���.FF���Hr�`���8��������1{o��H��MQ��@�۹�''j��?�t�C�����X_Ξ]��n�?�0�t�֊n���?�i�@��"*�;���#����鰦�b��R���s%���Q�2��GǄ�6�q��[���I�o����n���q��d�Ww� o]b��=�@>���\�*q��o���I���N�c��Ϟ�Q@��e���oڣ�ZfN�QT���<=�Y��|�V���/�_7;e!�+���)cF�/�o�F�#%��Oi%BƂ����޾c��P|����S,��:���u�Z]�3����4T����L�qi�#-�a�F!�.�w3B�o����#F��SV�3WOE=��7�Q&ӵ�̔�z2G��JŅ�q����J~�C�WG��0�,���|�)���0�H�kM��,��W��E��DWbQ�t��M~�+3��eatW��.L|'[��������ȐF�7ni[�H��'$����/�`�k��&�����)��S �{Aj�I�!av�~(0�5o�?��S=
�
B�-P�<ERr�!��S�gK9s�^3��1V�:�����.�'P�(��8#`��i�'2��'Zҩ;p.'��Ca�qi�ʚӬ�7:��r͚��儵��"�t���ǍW��W��p7����,:��Lh�#�B*׮�7 %U�W����ǀRs��K��ڰ�R����)7�qE�}�.��y���]u��s�ڷ�N1G��zGw�q0�D	k�'���/��4���O�d��g��ix]h���@��LKLl�E:q���y��KFf3T��?6���Yj n�l޷����VfjN�Q�(�cC�_���l�@�@�y-�"�٨6�}�PZ����öYrR�%���\Tt��\&2��)��%S���T�=��<[�7�h�
�?�nZa����9}�;�u~X�U�]\��e�h0�Sqp9�=��|�� �f��y��������Z'C$� �t3-e�
,K�/���}8`�ɦ(���W�.�f��D�(� r��2U�	��o�6j����Z5�3,=(�C퇀�eDoȡ�LYa����B�]�^N.N^} {�3_��ؿ�IO�tT�2����)}��X." �����������L�1t'�`	���Ut=��43)��ռ^�Vv��l.[ �nE�n�"*����3��v ����Z����e���f�m��n�f��?C|Q��]b���~'��ќ����&l9��,Y	9�ê�6]���M��B�G�0th%n�����Xt��$^Yl68�H�s!�;m"�����{8���!���#�:Fn$4H�tt)$f�
�_u�g�e<��yi��Ẩ6O؍���Y�<J�Rb��w�B���;<��f�ULr����������s�3L���&��oK�(�$�× �QFDy��Y�%g�ݫ��0>�bs���o��ћCB6
�1�q��Ws�G����3R�f��\2���h���W@�8)��gَ8���:f��l�<=���t�P@BK -9��]J{���]�"r�e���wl���o��בZ�.���s�hX��U.� �w���~P,G���4yS�Wj�ZB(��":�D��z��]�w(|R՘���(E�k��蝋�T�t��pu��*�����/}