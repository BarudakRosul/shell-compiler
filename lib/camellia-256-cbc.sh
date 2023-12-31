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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�ֈ���2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	m(66(q�#L��Lk;�@���ܧ���:���o�t�}B��k��؟�u*�7����󅀅d�pC)�'9�&�Y����$�9T?����ʇ��ǝy����I��P��Ȓ��Ӈ@坒�H��G��R<�{H�=��[�Ӊ2#��.  ��)����Q3�N��[��zf1���2�T�@U/��n�g�o�92��T@3��zx#��ڹ��8���=-��������ΠqV������� 1vT����������ØyY����JI�:��>���\">�$��WgqY��?w"���"�P YO�w%f�dd��N�`;�oh�+����	y)ޣ��Nޒ2?�On�G�́�W�v���E�B�Y�9Q�#SR|'���w?���+2xH ���)��W&�`��Wr�f�q1C<P��V��"0��
�i�����\w�~�Q���.�� �(f�ǟy]���G�ldWD�,";G�i\�!/8��A��Z,"��=b:˝Y���ݛX����#�������f��+;�bX�W�K�O��L��v�jQ@qg��ׂ#(�k s���Tۘo�,
�U������D��4'�5�w_w`���I3KXI����2-ӊ��������&D�w��e���n��EΈ�?�����:iDFO{r�^����T(b(�o<[Ke�Z��{�������ao|��^@��TW(�b�o�肉���n���6j�qN9ʅ��/l�g�LB�f��,����;���z���ÌZ�;�����+���M�Ŝ?iX�U�5|�s�z��(�����Xk	zG�e�H�U�4���Z�S�ܤ��jt{F1R�
7�$���̨sD{PJ ��)�>������C������.�o�<<���^�"��3�����$�8I�g� ��c�Kg�N����&j&�*e.*��+OLn�H"~:Ԃ�YG��S�|�Ѥ�
��zSe�Bz̦�#�������~ꛅ*����ͨ׭�.Eh�|]�ǹA�yf�[JP/�����hD���3��r����@�ƘY���хbQR���L���<�s���)��B��1\�Z���Zz���˙����0 �$ma!��Bg�_Ը�$�3)!3�,�^g����<o���9��/1W�Ko����S��g�!Y=\����V�§�����c�}�<J���f�p�5���B���gI���r_}�*ҳbB$�D�,т<;�>i���lb��ܑ�I�$���, �7m"��Ё`�(m�#����2�4�-,Dri�o������C�Tp$tF��<뭐q��%���c�z2e1�|���ձ����Q�-�fQ5 �'�,�r#H�l�'(+���!S3`��\r�N���R�����U���,@t�|�3x	G��F�%��y�.5�@R�iD��rC�@�IAv�|ItA���l�\39��5�������Wɦ��ё��2a�nb?)㧗���5\d�0��h&����j[��'R]s?@j8'�\-�t�yPSv�z�21*RW[x������N���N�xB�zxj�2/�����e�d@���s$��e����\��?�KѕV�gI��� ^lTwJ�
��w�s�PR+�/^��ҭfb�ܢ�JT��_��S"\uu�G��=����;�G�WHa������7/tJH�Q���D�F;;���e!�C�3��}&�{.�����9��n�mE���'s�ӛ�b%�(������ǘ��4�{�Ŋ��j�:|	q�U[�;�,�W�I��=���$۵I�`r�ML�ѭ
��Z�</�*��Yn�}IU�:¦�d���GcRP�L�k�[��>�}+�M��f�B'��z�ǹ7��F�7��c.mzY��}���y�Y����*%��ڧ� .��gܒ��M��+���}O�6�׋�$�M�)+w�<���62��`5I[����2���0x����^�
���&؜՞!��ȥ������ բ���b����U�$t�YV�X�sw!`,/�
[���)HAV_<r]��_�%�H�hu����mK����;�4V��ZE���ib�P����ɔ�I���~�RzD;{N����*��_�>�sK5%�Pt-G}��2 S��朸�ܰ|��:�F�+���w��˨\0.��}�����(�,����g�����>%jv�.Z�iU��F��o���e�8� �Ϯ�����Q[#���6A�zb�L����t�
��c�����wƒ������ZL�=��;?_(4#m<tFNS�ݒ�E]&���"~$��ʳ�,����?[l���f#�lZ��7������x���;�[�L�kΤ��u�-�q���_��ޔ�T����m�ХE�?ߚ�<�x!�X}+ �XmU�h}ٝd����ʫg�� �_?r��*A6r����ϕIKQ��l�u-<�~���B�a(bx�'|���&����h�nۚ�����h����p��&h�B��50�-x���Ɵ-�#}��ߣ�Y�픫��˗�@ld��PZ���K(쏽���������z�5��=���o� �>�m��iR�*`>��N�BP<y��C7OF��'IѠ��>ݠ��'q �Q��������mt��l<��bo�R[�w��o�6^"5��S'��P�z�Q'��)�K�2�z��A��ctF�z����-����8?��k@����[p�`>C_����S�:)�^C�j���-�w<J���U�d�.�)H�oC�3�����V4��tb�Z�@㗓pY�q��У�ץ�-[���_Y�#�����JD��3v���&���_�[�I\^Z3O��ZY���*ur�5Ar�p�,b�!�?��Ri`�W+;ҘpM^'����'Gn��7�y�����n����7�
�Ԓ\�s	�TqO��5ê(��<h�����.�"E`�t:�<�2��2������!�M�v2`�5��M ���OZmü�ԁ&.�3�!����p�u[��Z�O�铖��<�O�q�Zcli*���J�3�[��ɢ��p�}���!�Ds��-���t־A���܁��A��X�(�ꆲ�'J��(��e$�7��@�(`��Z��$(쎢ð��l�r{"Gq%�'��IP�7� �D�b�]6EE=��=ְU#*z��y��΄�:c�Iǒݍ��UH^�K��3M�π��drca4�i��F�k������i��B'tB��ԭ������9�˂��ʃ�f��j�%"T/�g�}n�Ϩz"cȨ6�zg�o����u��n���US�v��.Bf�{���@�=%��Bd�6�ꔰ�xg����&jDȠ�N�dߐ�>\����������,>���?�/*S��SLr��|`��ֆC`��b"�XH�4�qJ����$��H�m&�`Äd�U���zk
�fT�`���<�_�/��6���U�
��VȜ�+�(�3�����Eֽ!G�4�Ύ٠����k�.5q�+f����s���\��BR#gge��S��AJn��I��ƣ�aV�� ��ҿc���kV���8��T-!Ewq�}��,w��}"x72��L���'��^�Y�TJ���4췚C�/bHA����4CL�f
�[�g!���m��3��ZnKc��$T�m�`��S�O�s��&��畂G�B��&��)�ś��Q��'{K|ǲ�;�f	6���L�,��2'�<3e��B�c���ZC�< �p�jq�:
=d�	Z��D,J&l%A�E��,z�9�ٖ=�F;;�$�#G�\U�и�*NLK��;�h.��M�b�`h+����7*o,J����f�z-i��K�4�7�<���D}#}�o�č���Ixv����C
/��0|�$�/-�ߕ�8ȓET��aP0���
����#;�='�@N��0"Ͷ��(iD�}B\�Gِ�<�4��CMos�W4ܵj�ed����?�>�3L侠[�uǬՓ��c>�2Q��gD���|(_=�J��F�+�1E;�^���nk"�p������ca�+�����I