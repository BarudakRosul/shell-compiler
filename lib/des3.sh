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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�M��B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}�����@�&|s_�#�u�B��:QTXz�Ы^�|̶׬J��0�R�i�_24�hY��o��m�^alQ-�OTc\4ny��높���������^�� �m�N릁�et�
�FeA�^��	t�MX�{�"��hK�,�`/Ԉ�]l��1:%����O��[ַ�+qA^��aJ彤9U��ӏ�4�)�W�h���k�ӽ\u6,&݃���I������G �^@�dݧ�?c �[�w�QE=fԻY6 	���Y�`��4]�&80痺a�"���@kݤ"Ld;���@�s�fJ����+���tΕ��+K�)G���ĩg:���C~��iS���%�Xs���h� ��Z�doP�!�ȊZ��� �+�����OT�;�x��xB83{+���/6�O��w͡��?7�ۙ���i;>���c�0`��.�Z�j���یJ��+�w6�&}�[�"\��6##�mM���[$���A-�#*�{����ː�:}�hƶ�\d�u�%��Jl���;�����"��ZuXo#����dx�t0��͗zV�]6rQa�JMxM��#�՝kk�n�u9+�z<�[�o�ꯧ'�Iʶ�O���l��o��.w�a)7�����+w�(��&�=3p�M��1�S:���y�y��7;U�}�.1�m��	���,}8��B^ʹ�PX��,}�p�H�ڔd�ڦ0Y�˼���܊�zT({�@g˚S@#RQ=0?�(�����`��8>�Sm�z�W2Je���k���aH��\Dz� ��ٵ �\�y��G)��kS�04C��Ἠ���"����4 �>r0���󳌶�j�����_1Z�&,��̝X��9~�(��9M�w+�--CI �7a¹lw��6{^���t�m�f�Ǒ�I�p��LL���kw��㖉�A h �p�I;���wW{~��$���;)��lc�Λw�閠��>�����[]���}�W��E�ZB���+�'�Z�����{��/��]����{H���{�g����t����OX�'_�g7)�tS�����ȟk�>�e�O�D����&W�t��KSa7U$)KKD\�R�k������eTl/�[�;��@>k�
�d�2��j�� ;� �w�nKK����2��8O�Ӓ�/����	b��E�૥�Nb|{՝���m�T��-���� H�l@]���x%�UL�����7_�C���U�<��!�C��[��ӭF�D@���k��0Î��rN#�5�#�f���;E��:Ǔ?f:��G���5W�p�:����j' #����׻�̀��ϧ��
�t��͸���y���j�g���2n π@��h�V�GZ�z�5H`�2�y��ra<ӂ�4h���_&ͼ="ETt����^T�cO���$*�W{�`p���"�_����4 �*і� �tz��ׂ�@�WL��
�f|�XP'�����C�6�/��ا##[��a�-s�ݿ;_F�p��4�A'Su��]�R�o5ٚJ��Qg�d`���@����O���O\X\��\;�,�L~_ڳ�80�:�j�Xq�ۼ�l8�"�����/��K���.͊�jܗ|l1�n�Jd�w����Z��������"��Ojf�MU蔋͏3������g-=�|����5��_
���z6�z'P/�I�v�����)�aM:tfa�Q̮�IFB��#f�K���s怼�g�m�2>���`�4��#��T�h|�x��<⮜F'�}�a��W���l���t��؆�J�`Omi<�|QF���L���Fp�;S���r��
+u�,�H�^wB��-�M���|��;�g�H�m!e��8�H��t�h���:,�I>����g_�}uB��5e[m4φ-�X���{���O��-����������E��'f�D$[�Υ�7��=�X#H
���g>���:�6�c�N���w�t���zr�w���!og6�������P���<%���ӋB~(��$+mJ���,��"�}<#x>�b>c�i��(��,�[������v�>��El;��2`
O1��2g�=V�F��\{�󤐆��b[�t����CI�߰���Qj��.�!�t�M�ոb���=����������qw�������6�|G�t�]�Bs�\��Z,��Ͽ��Vi���T7�(\'z%�8���C^���²LN~^b':"���=���آ�s�J�!J�-G>�NFC�T��'s�m(Y�f��Yi# \ԏ;�K���2( V9�/�g���og:��[2�$eO�m��m�= i�[�~m3���L�w��a�ag�c�)Z#��L*oO�(�4X�=����i�3qX�Ɇ���QZl�ا��L}�x��~�
|���j
��\�D7�i�J1M�
Ե�����q�ĘBH�b�5h~q���/���[ZE�V��s�����780{=n|�6�\�C�}G�Н�?c�Њ��� D�T��	�Hl������4q�`҉\g) 7��7���|��
�5?0��ϔ�q�n�fP~��ې������K�Y̟OczD�#�_����nA��q0�B���?�`jm�v
�@ >F2�<��
g
	)���T5MrO���C��7?0��F�aH��]Ό�f�~���vW��6�G�O��#���B��H����cY����r�l�M�Jl4^��y+!u���l
v��Dn�J��{���j�>�����JF|[��@h�2f=� uԘY�F��BR��r���߰z�a��p1�~0-���;HA�����?Y���t�͎��x�<�C�歽z�J�eCd 8�}B���|��7�����,�D�q��.尷��A �=s��U3�b���A���5���l�����ns6%�7���M6��
�����)Hq�H���>�|���P���{���Ԋ3��{N ��U�KՅԚ��@�@�����t��<��_�U�?EMy�psfm{LF��l_��`���դ���
�4�>�X���ʉ�٤���QoVĔ?��\b�̓�U�c{���8fuY;��~ĝ9��N���8�vBN�6K��Q�ս~��).���TB�F����_�!,h3ki?�㹲�������sѴd�F�B��V�ڀ�Н:f��p~]@K���0����z�C|��?�5�P���u G
�֠@s�~�m�ַ���s��5 ���[=Q�8����ѻ�BH�^źv�H�?t�{�ܣ���2�S���'�=ip��������ةZ�h��?Ȇ�����ײ�H�rتh6�� �1� 85N-|�Sz���	��]ܙuWw����T2�\�U�����.2̓T�9
Cs�Z)�\�$���X/H���b$�gg��sE?���Y�����(ba�V(;�lC�/�J'�6�p�<���+)�H�y��s6TP���F�+��p�)�a���U�:|_�����+itN`�=��-��E�~j��=D93�T[��!�cW��?,=����R��2�ߍ/�8gi����R��"��C��8}G�'��V�b1ڧ�,L
�a��K5��T�O}��	�{̑a::�2Zvx{z�����^~əظ^��0���MkJ��m�`�|o�觿�}k�ձ�X&���;Z�iS^Lt���t��`�Gzf�6��21���X\ӵ2?̎	�ygd嚰a
e�����-�'�mį���ʹŻF��Oܳ��6��jY���zу׳oͺ�7�%G���<~Ū%/L�ӂ:���$NÙ���Et֠��������\�V���3^˴�2�];� l�2ZMc��DA}DJ�.�t�>:TPD'�r$G�#�>��]�c>�}�_�)6�|=�y)��p�Ib�P���Xe��x�&��h�T0>@�����΄ '��K�v��`Fgz�g�d���5��ـ�	��Zv��e�w�����4�����